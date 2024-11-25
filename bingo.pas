Program JuegoDeBingo;

Uses crt, sysutils;

Const 
  FILAS = 5;
  COLUMNAS = 5;
  MAX_BOLAS = 75;

Type 
  TCartones = array Of array Of array[1..FILAS, 1..COLUMNAS] Of integer;
  TMarcados = array Of array Of array[1..FILAS, 1..COLUMNAS] Of boolean;

Var 
  Cartones: TCartones;
  Marcados: TMarcados;
  Bolas: array[1..MAX_BOLAS] Of boolean;
  SecuenciaBolas: array[1..MAX_BOLAS] Of integer;
  Jug, CartPorJug, BolaActual: integer;


Procedure GenerarCarton(jugador, carton: integer);

Var 
  i, j, numero, minColumna, maxColumna: integer;
  NumerosUsados: array[1..75] Of boolean;
Begin
  FillChar(NumerosUsados, SizeOf(NumerosUsados), False);
  For j := 1 To COLUMNAS Do
    Begin
      minColumna := (j - 1) * 15 + 1;
      maxColumna := j * 15;
      For i := 1 To FILAS Do
        Begin
          Repeat
            numero := Random(maxColumna - minColumna + 1) + minColumna;
          Until Not NumerosUsados[numero];
          NumerosUsados[numero] := True;
          Cartones[jugador, carton, i, j] := numero;
          Marcados[jugador, carton, i, j] := False;
        End;
    End;
  Marcados[jugador, carton, 3, 3] := True;
  Cartones[jugador, carton, 3, 3] := 0;
End;


Procedure MostrarCarton(jugador, carton: integer);

Var 
  i, j: integer;
Begin
  writeln('_____________________');
  writeln('| B | I | N | G | 0 |');
  writeln('|___|___|___|___|___|');
  For i := 1 To FILAS Do
    Begin
      For j := 1 To COLUMNAS Do
        Begin
          If Marcados[jugador, carton, i, j] Then
            Begin
              TextColor(Green);
              Write(' X  ');
              TextColor(White);
            End
          Else If Cartones[jugador, carton, i, j] = 0 Then
                 Write('    ')  
          Else
            Write(Cartones[jugador, carton, i, j]:3, ' ');
        End;
      writeln('|');
      writeln('|___|___|___|___|___|');
    End;
End;


Function Min(a, b: integer): integer;
Begin
  If a < b Then
    Min := a
  Else
    Min := b;
End;


Procedure MostrarCartonesSeparado;

Var 
  jugador, carton, pagina, cartonesPorPagina, totalCartones, maxPaginas: integer
  ;
  tecla: char;
Begin
  cartonesPorPagina := 2;
  totalCartones := CartPorJug;

  For jugador := 1 To Jug Do
    Begin
      pagina := 1;
      maxPaginas := (totalCartones Div cartonesPorPagina) + Ord(totalCartones
                    Mod cartonesPorPagina > 0);

      Repeat
        clrscr;
        writeln('Cartones del Jugador ', jugador, ', Pagina ', pagina);
        For carton := (pagina - 1) * cartonesPorPagina + 1 To Min(pagina *
            cartonesPorPagina, totalCartones) Do
          Begin
            If (carton >= 1) And (carton <= totalCartones) Then
              MostrarCarton(jugador, carton);
          End;

        writeln;
        writeln(
   'Presiona "Enter" para continuar a la siguiente pagina o "Esc" para salir...'
        );

        Repeat
          tecla := ReadKey;
        Until (tecla = #13) Or (tecla = #27);

        If tecla = #13 Then
          Inc(pagina) 
        Else If tecla = #27 Then
               Break;

      Until pagina > maxPaginas;
    End;
End;


Procedure InicializarJuego;

Var 
  inputValido: boolean;
  entrada: string;
  valor: LongInt;
  i, j : Integer;

Function EsNumero(Const s: String): boolean;

Var 
  k: integer;
Begin
  EsNumero := True;
  For k := 1 To Length(s) Do
    If Not (s[k] In ['0'..'9']) Then
      Exit(False);
End;

Begin
  Randomize;
  FillChar(Bolas, SizeOf(Bolas), False);
  BolaActual := 0;

  Repeat
    clrscr;
    writeln('Cuantos jugadores participaran? (1-10)');
    readln(entrada);
    inputValido := EsNumero(entrada) And (TryStrToInt(entrada, valor)) And (valor >= 1) And (valor <= 10);
    If Not inputValido Then
    begin
      writeln('Por favor, ingresa un numero entre 1 y 10.');
      WriteLn('Presione Enter para reintentar.');
      While ReadKey <> #13 Do;
    end;  
  Until inputValido;
  Jug := valor;

  Repeat
    clrscr;
    writeln('Cuantos cartones por jugador? (1-5)');
    readln(entrada);
    inputValido := EsNumero(entrada) And (TryStrToInt(entrada, valor)) And (valor >= 1) And (valor <= 5);
    If Not inputValido Then
    begin
      writeln('Por favor, ingresa un numero entre 1 y 5.');
      WriteLn('Presione Enter para reintentar.');
      While ReadKey <> #13 Do;
    end;
  Until inputValido;
  CartPorJug := valor;

  SetLength(Cartones, Jug + 1, CartPorJug + 1);
  SetLength(Marcados, Jug + 1, CartPorJug + 1);

  For i := 1 To Jug Do
    For j := 1 To CartPorJug Do
      GenerarCarton(i, j);
End;


Procedure MostrarBienvenida;
Begin
  ClrScr;
  TextColor(LightBlue);
  Writeln('********************************************');
  Writeln('***            BIENVENIDO AL            ***');
  Writeln('***         JUEGO DE BINGO DIGITAL      ***');
  Writeln('********************************************');
  TextColor(White);
  Writeln('Presiona Enter para comenzar...');
  While ReadKey <> #13 Do;
End;


Procedure SortearBola;

Var 
  bola: integer;
Begin
  Repeat
    bola := Random(MAX_BOLAS) + 1;
  Until Not Bolas[bola];
  Bolas[bola] := True;
  Inc(BolaActual);
  SecuenciaBolas[BolaActual] := bola;
End;


Procedure MarcarCartones(bola: integer);

Var 
  jugador, carton, i, j: integer;
Begin
  For jugador := 1 To Jug Do
    For carton := 1 To CartPorJug Do
      For i := 1 To FILAS Do
        For j := 1 To COLUMNAS Do
          If Cartones[jugador, carton, i, j] = bola Then
            Marcados[jugador, carton, i, j] := True;
End;


Function ObtenerLetra(bola: integer): char;
Begin
  If (bola >= 1) And (bola <= 15) Then
    ObtenerLetra := 'B'
  Else If (bola >= 16) And (bola <= 30) Then
         ObtenerLetra := 'I'
  Else If (bola >= 31) And (bola <= 45) Then
         ObtenerLetra := 'N'
  Else If (bola >= 46) And (bola <= 60) Then
         ObtenerLetra := 'G'
  Else
    ObtenerLetra := 'O';
End;


Procedure MostrarBolaSorteada(bola: integer);

Var 
  letra: char;
Begin
  letra := ObtenerLetra(bola);
  writeln('Bola sorteada: ', letra, bola);
End;


Procedure MostrarBolasSorteadas;

Var 
  i: integer;
  bola: integer;
  letra: char;
Begin
  WriteLn;
  writeln('========Bolas sorteadas hasta ahora========');
  WriteLn;
  For i := 1 To BolaActual Do
    Begin
      bola := SecuenciaBolas[i];
      letra := ObtenerLetra(bola);
      Write(letra, bola, ' ');
    End;
  writeln;
End;


Function VerificarLinea(jugador, carton: integer): boolean;

Var 
  i, j: integer;
  lineaCompleta: boolean;
Begin
  VerificarLinea := False;
  
  For i := 1 To FILAS Do
    Begin
      lineaCompleta := True;
      For j := 1 To COLUMNAS Do
        If Not Marcados[jugador, carton, i, j] Then
          lineaCompleta := False;
      If lineaCompleta Then
        Begin
          VerificarLinea := True;
          Exit;
        End;
    End;

  For j := 1 To COLUMNAS Do
    Begin
      lineaCompleta := True;
      For i := 1 To FILAS Do
        If Not Marcados[jugador, carton, i, j] Then
          lineaCompleta := False;
      If lineaCompleta Then
        Begin
          VerificarLinea := True;
          Exit;
        End;
    End;

  lineaCompleta := True;
  For i := 1 To FILAS Do
    If Not Marcados[jugador, carton, i, i] Then
      lineaCompleta := False;
  If lineaCompleta Then
    Begin
      VerificarLinea := True;
      Exit;
    End;

  lineaCompleta := True;
  For i := 1 To FILAS Do
    If Not Marcados[jugador, carton, i, FILAS - i + 1] Then
      lineaCompleta := False;
  If lineaCompleta Then
    VerificarLinea := True;
End;


Function VerificarBingo(jugador, carton: integer): boolean;

Var 
  i, j: integer;
Begin
  VerificarBingo := True;
  For i := 1 To FILAS Do
    For j := 1 To COLUMNAS Do
      If Not Marcados[jugador, carton, i, j] Then
        VerificarBingo := False;
End;


Procedure Jugar;

Var 
  i, j: integer;
  bingo, linea: boolean;
Begin
  Repeat
    writeln('Presiona Enter para sortear la siguiente bola...');
    While ReadKey <> #13 Do;
    clrscr;

    SortearBola;
    MostrarBolaSorteada(SecuenciaBolas[BolaActual]);
    MostrarBolasSorteadas;

    WriteLn;
    writeln('Presiona Enter para continuar...');
    While ReadKey <> #13 Do;
    clrscr;

    MostrarCartonesSeparado;
    MarcarCartones(SecuenciaBolas[BolaActual]);

    For i := 1 To Jug Do
      For j := 1 To CartPorJug Do
        Begin
          linea := VerificarLinea(i, j);
          bingo := VerificarBingo(i, j);

          If linea Then
            writeln('El Jugador ', i,' ha completado una linea en el carton numero ', j);
          If bingo Then
            Begin
              clrscr;
              TextColor(LightBlue);
              Writeln('********************************************');
              Writeln('***         BINGO! El Jugador ', i:2, '         ***');
              Writeln('***  ha ganado con el carton numero ', j:2, '    ***');
              Writeln('********************************************');
              TextColor(White);
              WriteLn;
              Writeln('Presiona Enter para terminar el juego y volver al menu.');
              While ReadKey <> #13 Do;
              Exit;
            End;
        End;
  Until False;
End;


Procedure MostrarMenu;

Var 
  opcion: char;
Begin
  Repeat
    clrscr;
    writeln('============ MENU PRINCIPAL ============');
    writeln('1. Iniciar Juego');
    writeln('2. Leer Reglas');
    writeln('3. Salir');
    writeln;
    write('Selecciona una opcion: ');
    opcion := ReadKey;
    writeln(opcion);

    Case opcion Of 
      '1':
           Begin
             clrscr;
             InicializarJuego;
             Jugar;
           End;
      '2':
           Begin
            clrscr; 
            writeln('============ REGLAS DEL JUEGO ============');
            writeln('- Cada jugador puede elegir entre uno o mas cartones.');
            writeln('- Se sortearan bolas con numeros del 1 al 75.');
            writeln('- Gana el jugador que complete el Bingo primero.');
            writeln;
            writeln('Presiona Enter para volver al menu.');
            While ReadKey <> #13 Do;
           End;
      '3':  
          begin
            clrscr;
            TextColor(LightBlue);
            Writeln('********************************************');
            Writeln('***                                      ***');
            Writeln('***           Gracias por jugar          ***');
            Writeln('***                                      ***');
            Writeln('********************************************');
            TextColor(White);
            sleep(3000); 
          end;  

      Else
        Begin
          writeln('Opcion invalida. Intentalo de nuevo.');
          writeln('Presiona Enter para volver al menu.');
          While ReadKey <> #13 Do;
        End;
    End;
  Until opcion = '3';
End;


Begin
  clrscr;
  MostrarBienvenida;
  MostrarMenu;
End.

