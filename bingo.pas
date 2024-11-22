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
  Jugadores, CartonesPorJugador, TotalCartones, BolaActual: integer;

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
  writeln('Carton del Jugador ', jugador, ', Carton numero ', carton, ':');
  writeln(' B   I   N   G   O');
  For i := 1 To FILAS Do
    Begin
      For j := 1 To COLUMNAS Do
        Begin
          If Marcados[jugador, carton, i, j] Then
            Write(' X  ')
          Else If Cartones[jugador, carton, i, j] = 0 Then
                 Write('    ')
          Else
            Write(Cartones[jugador, carton, i, j]:3, ' ');
        End;
      writeln;
    End;
End;
procedure Leercantidad(Var cantidad:integer; mensaje: string);
var
valido: boolean;
begin
   repeat
      writeln(mensaje);
      readln(cantidad);
      valido:= (cantidad > 0);
      if not valido then 
         writeln('Por favor, ingrese un número entero positivo');
   until
end;
Procedure InicializarJuego;

Var 
  i, j: integer;
Begin
  Randomize;
  FillChar(Bolas, SizeOf(Bolas), False);
  BolaActual := 0;

  writeln('Cuantos jugadores son?');
  readln(Jugadores);

  writeln('Cuantos cartones por jugador?');
  readln(CartonesPorJugador);

  TotalCartones := Jugadores * CartonesPorJugador;

  SetLength(Cartones, Jugadores + 1, CartonesPorJugador + 1);
  SetLength(Marcados, Jugadores + 1, CartonesPorJugador + 1);

  For i := 1 To Jugadores Do
    For j := 1 To CartonesPorJugador Do
      GenerarCarton(i, j);
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
  For jugador := 1 To Jugadores Do
    For carton := 1 To CartonesPorJugador Do
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
  ganadorJugador, ganadorCarton, i, j: integer;
  bingo, linea: boolean;
Begin
  ganadorJugador := 0;
  ganadorCarton := 0;

  Repeat
    writeln('Presiona una tecla para sortear la siguiente bola...');
    ReadKey;
    SortearBola;
    clrscr;
    MostrarBolaSorteada(SecuenciaBolas[BolaActual]);

    MarcarCartones(SecuenciaBolas[BolaActual]);


    For i := 1 To Jugadores Do
      For j := 1 To CartonesPorJugador Do
        MostrarCarton(i, j);

  
    For i := 1 To Jugadores Do
      For j := 1 To CartonesPorJugador Do
        Begin
          linea := VerificarLinea(i, j);
          bingo := VerificarBingo(i, j);

          If linea Then
            writeln('El Jugador ', i,' ha completado una linea en el carton numero', j);
          If bingo Then
            Begin
              ganadorJugador := i;
              ganadorCarton := j;
              writeln('El Jugador ', i, ' ha hecho Bingo en el carton numero', j);
              Break;
            End;
        End;

  Until ganadorJugador <> 0;

  writeln('¡Juego terminado! El Ganador es el Jugador ', ganadorJugador,' con el carton numero', ganadorCarton);
End;

Begin
  clrscr;
  InicializarJuego;
  Jugar;
End.
