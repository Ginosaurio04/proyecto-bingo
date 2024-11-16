program bingo;

type
    carton = array[1..5,1..5] of Integer;
    cartonCheck = array[1..5,1..5] of Boolean;
jugador = record
jugador: String;
 cartones : array of carton;
  verificadores : array of cartonCheck;
end;
jugadores = array of Jugador;