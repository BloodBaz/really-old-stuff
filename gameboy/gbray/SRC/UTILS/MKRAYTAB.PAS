program MakeRayTable;
	const
		MAX_RAY_VAL = $2000;
	var T:text;
		i:word;
		X,Y:real;
		N:real;
Begin
	Assign(T,'..\RAYTABLE.H');
	Rewrite(T);

	Writeln(T,'#define _ANG_0     0');
	Writeln(T,'#define _ANG_90   64');
	Writeln(T,'#define _ANG_180 128');
	Writeln(T,'#define _ANG_270 192');
	Writeln(T);

	Writeln(T,'WORD xray_tabl[]={');
	for i:=0 to 255 do
		begin
			if i <> 0 then
				Writeln(T,',');
			X:=Cos(PI*i/128);
			Y:=Sin(PI*i/128);
			if Round(X*100000) <> 0 then {Maldito ponto flutuante!!}
				begin
					N:=Round((Y/Abs(X))*256);
				end
			else
				begin
					if Y < 0 then
						N:=-MAX_RAY_VAL
					else if Y > 0 then
						N:=MAX_RAY_VAL
					else
						N:=0;
				end;
			if N > MAX_RAY_VAL then
				N:=MAX_RAY_VAL;
			if N < -MAX_RAY_VAL then
				N:=-MAX_RAY_VAL;
			Write(T,Round(N));
		end;
	Writeln(T);
	Writeln(T,'};');
	Writeln(T);

	Writeln(T,'WORD yray_tabl[]={');
	for i:=0 to 255 do
		begin
			if i <> 0 then
				Writeln(T,',');
			X:=Cos(PI*i/128);
			Y:=Sin(PI*i/128);
			if Round(Y*100000) <> 0 then {Maldito ponto flutuante!!}
				begin
					N:=Round((X/Abs(Y))*256);
				end
			else
				begin
					if X < 0 then
						N:=-MAX_RAY_VAL
					else if X > 0 then
						N:=MAX_RAY_VAL
					else
						N:=0;
				end;
			if N > MAX_RAY_VAL then
				N:=MAX_RAY_VAL;
			if N < -MAX_RAY_VAL then
				N:=-MAX_RAY_VAL;
			Write(T,Round(N));
		end;
	Writeln(T);
	Writeln(T,'};');
	Writeln(T);

	Writeln(T,'WORD xdist_tabl[]={');
	for i:=0 to 255 do
		begin
			if i <> 0 then
				Writeln(T,',');
			X:=Cos(PI*i/128);
			Y:=Sin(PI*i/128);
			if Round(X*100000) <> 0 then {Maldito ponto flutuante!!}
				begin
					N:=(Y/X)*256;
				end
			else
				begin
					N:=MAX_RAY_VAL;
				end;
			if N > MAX_RAY_VAL then
				N:=MAX_RAY_VAL;
			N:=Sqrt(Sqr(N)+Sqr(256.0));
			Write(T,Round(N));
		end;
	Writeln(T);
	Writeln(T,'};');
	Writeln(T);

	Writeln(T,'WORD ydist_tabl[]={');
	for i:=0 to 255 do
		begin
			if i <> 0 then
				Writeln(T,',');
			X:=Cos(PI*i/128);
			Y:=Sin(PI*i/128);
			if Round(Y*100000) <> 0 then {Maldito ponto flutuante!!}
				begin
					N:=(X/Y)*256;
				end
			else
				begin
					N:=MAX_RAY_VAL;
				end;
			if N > MAX_RAY_VAL then
				N:=MAX_RAY_VAL;
			N:=Sqrt(Sqr(256.0)+Sqr(N));
			Write(T,Round(N));
		end;
	Writeln(T);
	Writeln(T,'};');
	Writeln(T);

	Writeln(T,'UBYTE dist_scale_tabl[]={');
	for i:=0 to 255 do
		begin
			if i <> 0 then
				Writeln(T,',');
			N := 191/((i/2)+1);
			Write(T,Round(N));
		end;
	Writeln(T);
	Writeln(T,'};');
	Writeln(T);

	Writeln(T,'WORD cos_tabl[]={');
	for i:=0 to 255 do
		begin
			if i <> 0 then
				Writeln(T,',');
			N := Cos(PI*i/128)*128;
			Write(T,Round(N));
		end;
	Writeln(T);
	Writeln(T,'};');
	Writeln(T);

	Close(T);
End.