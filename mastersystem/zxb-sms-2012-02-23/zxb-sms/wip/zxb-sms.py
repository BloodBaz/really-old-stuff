from version import VERSION

import sys, os, inspect, optparse, getpass
import subprocess
from subprocess import Popen, PIPE



class Exec(object):
    """Executes a program."""
    
    def __init__(self, prog):
        self._prog = prog
        self._cmdline = []

    def execute(self):
        """Calls the program,
        dumps its stdout and stderr to the current process' equivalents,
        and returns the return code.
        """

        # To prevent a terminal window from popping up
        CREATE_NO_WINDOW = 0x8000000

        # Executes the program
        proc = Popen(self._build_param_list(),
                     stdout=PIPE, stderr=PIPE,
                     universal_newlines=True,
                     creationflags = CREATE_NO_WINDOW)
        (so, se) = proc.communicate()
        sys.stdout.write(so)
        sys.stderr.write(se)

        return proc.returncode

    def add_param(self, param, param2 = None):
        """Adds a param to the commandline of the called program.
        returns: self (for easy chaining)
        """
        self._cmdline.append((param, param2))
        
        return self

    def _build_param_list(self):
        """Builds the param list that will be passed to Popen"""
        lst = [self._prog]
        for op in self._cmdline:
            lst.append(str.join(' ', [x for x in op if x != None]))
        return lst




class Options(object):
    """Class responsible for holding the options for the builder."""
    
    def __init__(self):
        return
        

    def add_options(self, options):
        """Sets the options
        Receives, as a parameter, an object or dictionary containing the
        options to set;
        options that aren't present on that object are simply left untouched.
        """
        if (options == None):
            return

        for k, v in self._to_dict(options).items():
            if v != None or not hasattr(self, k):
                setattr(self, k, v)


    def _to_dict(self, o):
        """Converts an object's attributes into a dictionary.
        If it's already one, then just returns it.
        """
        if isinstance(o, dict):
            return o
        
        return {k: v for (k, v) in inspect.getmembers(o)
                    if not k.startswith('__') and not hasattr(v, '__call__')}




class Builder(object):
    """Executes the full build process.
    Compiles the ZX Basic source, converts the asm to WLA-Z80 format,
    assembles and links it.
    """

    def __init__(self, options = None):
        self._options = Options()
        

    def add_options(self, options):
        """Sets the options
        Receives, as a parameter, an object or dictionary containing the
        options to set;
        options that aren't present on that object are simply left untouched.
        """
        if (options == None):
            return

        self._options.add_options(options)


    def build(self):
        """Executes the build process"""

        return self._compile_resource() or\
               self._compile_basic() or\
               self._translate_asm() or\
               self._assemble() or\
               self._link() or\
               self._cleanup()

    def _compile_resource(self):
        """Compiles the resource file"""
        
        op = self._options
        if op.resource_file is None:
            return 0
        
        ex = self._create_exec(op.zxbwla_dir, 'zxbres.exe')
        ex.add_param(op.resource_file)
        ex.add_param('--zxb=' + op.resource_zxi_file)
        ex.add_param('--wla=' + op.resource_inc_file)
            
        return self._handle_exec(ex,
                                 '\nResource processing failed.\n')

    def _compile_basic(self):
        """Compiles the ZX Basic source"""
        
        op = self._options
        ex = self._create_exec(op.zxbasic_dir, 'zxb.exe')
        ex.add_param(op.input_file)
        ex.add_param('--asm')
        ex.add_param('--output=' + op.zxb_asm_file)
            
        return self._handle_exec(ex,
                                 '\nCompilation failed.\n')


    def _translate_asm(self):
        """Translates the assembly generated by ZXB to the WLA-Z80 format."""

        op = self._options
        ex = self._create_exec(op.zxbwla_dir, 'zxb2wla.exe')
        ex.add_param(op.zxb_asm_file)
        ex.add_param('--output=' + op.wla_asm_file)

        self._pass_param(ex, 'banks', op.bank_count)
        self._pass_param(ex, 'prg_version', op.prg_version)
        self._pass_param(ex, 'prg_name', op.prg_name)
        self._pass_param(ex, 'notes', op.prg_notes)
        self._pass_param(ex, 'author', op.prg_author)
        self._pass_param(ex, 'lib_dir', op.wla_lib_dir)
        self._pass_param(ex, 'include', op.resource_inc_file)

        return self._handle_exec(ex,
                                 '\nTranslation failed.\n')


    def _assemble(self):
        """Uses WLA-Z80 to assemble the ASM file."""

        op = self._options
        ex = self._create_exec(op.wla_dir, 'wla-z80.exe')
        ex.add_param('-o')
        ex.add_param(op.wla_asm_file)
        ex.add_param(op.wla_obj_file)
            
        return self._handle_exec(ex,
                                 '\nAssembly failed.\n')


    def _link(self):
        """Uses WLALINK to generate the ROM."""

        self._generate_link_file()

        op = self._options
        ex = self._create_exec(op.wla_dir, 'wlalink.exe')
        ex.add_param('-drvs')
        ex.add_param(op.wla_link_file)
        ex.add_param(op.output_file)
            
        return self._handle_exec(ex,
                                 '\nLinking failed.\n')


    def _generate_link_file(self):
        """Generates the link file that WLALINK requires."""

        op = self._options
        f = open(op.wla_link_file, 'w')
        f.write('[objects]\n')
        f.write(op.wla_obj_file)
        f.flush()
        f.close()


    def _cleanup(self):
        """Cleans up the temporary files."""

        op = self._options
        if not op.do_cleanup:
            return 0
        
        os.remove(op.zxb_asm_file)
        os.remove(op.wla_obj_file)
        os.remove(op.wla_link_file)

        return 0


    def _create_exec(self, directory, executable):
        """Creates an instance of Exec()"""
        return Exec(os.path.normpath(directory + '/' + executable))


    def _handle_exec(self, ex, message):
        """Executes an instance of Exec and handles the errors, if any."""
        err = ex.execute()
        if err > 0:
            sys.stderr.write(message)
        return err

    def _pass_param(self, ex, name, value):
        """Passes a param to Exec, if the value is not None."""

        if value != None:
            ex.add_param('--%s=%s' % (name, value))
        





class Main(object):
    """Reads the commandline and executes the program functions accordingly.
    """

    def __init__(self, args):
        self._args = args
        return


    def execute(self):
        err = self._read_arguments()
        if err > 0:
            return err
        

    def _read_arguments(self):
        parser = self._create_option_parser()
        (options, args) = parser.parse_args()

        if len(args) != 1:
            parser.error("missing input file. (Try -h)")
            return 3

        options.input_file = os.path.basename(args[0])
        if options.output_file is None:
            options.output_file = self._replace_extension(options.input_file, '.sms')
            
        if options.resource_file is None:
            rsc = self._replace_extension(options.input_file, '.rsc')
            if os.path.isfile(rsc):
                options.resource_file = rsc

        options.zxb_asm_file = self._replace_extension(options.output_file, '.asm.tmp')
        options.wla_asm_file = self._replace_extension(options.output_file, '.asm')
        options.wla_obj_file = self._replace_extension(options.output_file, '.o')
        options.wla_link_file = self._replace_extension(options.output_file, '.lk')        

        if options.resource_file is None:
            options.resource_zxi_file = None
            options.resource_inc_file = None
        else:
            options.resource_zxi_file = self._replace_extension(options.resource_file, '.zxi')
            options.resource_inc_file = self._replace_extension(options.output_file, '.rsc.inc')
        
        builder = Builder()
        builder.add_options(options)
        
        return builder.build()


    def _create_option_parser(self):
        parser = optparse.OptionParser(usage='Usage: %prog <inputfile> [options]',
                                    version='%prog ' + VERSION,
                                    description="""Compiles a Sega Master System ROM from a ZX Basic source file.""")
        parser.add_option("-o", "--output", type="string", dest="output_file",
                help="sets output file. Default is input filename with .sms extension", default=None)
        parser.add_option("--resource", type="string", dest="resource_file",
                help="sets resource file to use. Default is input filename with .rsc extension, if it exists.")
        parser.add_option("--banks", type="int", dest="bank_count",
                help="sets number of ROM banks.")        
        parser.add_option("--prg_version", type="float", dest="prg_version",
                help="sets compiled program version.")
        parser.add_option("--prg_name", type="string", dest="prg_name",
                help="sets program name")
        parser.add_option("--notes", type="string", dest="prg_notes",
                help="sets program notes")
        parser.add_option("--author", type="string", dest="prg_author",
                help="sets author name.")
        parser.add_option("--zxbasic_dir", type="string", dest="zxbasic_dir",
                help="sets ZX Basic installation dir", default=self._get_default_dir("./zxb"))
        parser.add_option("--zxbwla_dir", type="string", dest="zxbwla_dir",
                help="sets ZXB2WLA installation dir", default=self._get_default_dir("./"))
        parser.add_option("--wla_dir", type="string", dest="wla_dir",
                help="sets WLA installation dir", default=self._get_default_dir("./wla"))
        parser.add_option("--lib_dir", type="string", dest="wla_lib_dir",
                help="sets WLA library dir", default=self._get_default_dir("/../lib/wla"))
        parser.add_option("--no_cleanup", action="store_false", dest="do_cleanup", default=True,
                help="don't delete temporary files after build")
        return parser


    def _get_current_user(self):
        return getpass.getuser()

        
    def _get_default_dir(self, dirname):
        try:
            script_dir = os.path.dirname(os.path.realpath(sys.argv[0]))
            return os.path.relpath(os.path.normpath(script_dir + dirname)) + os.sep
        except:
            return "./"


    def _replace_extension(self, filename, newext):
        return os.path.splitext(os.path.basename(filename))[0] + newext
    





##############
# Main routine
##############
if __name__ == '__main__':
    sys.exit(Main(sys.argv).execute()) # Exit
