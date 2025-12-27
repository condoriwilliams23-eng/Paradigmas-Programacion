Base de datos 2
Posee dos cadenas posibles de 3 pacientes. También hay una de 6 pacientes, la cual será la óptima, ya que las anteriores poseen prioridades mínimas muy bajas. 

paciente(dni(101), nombre("P", "Uno"), tiempo_espera(10)).
paciente(dni(102), nombre("P", "Dos"), tiempo_espera(10)).
paciente(dni(103), nombre("P", "Tres"), tiempo_espera(40)).
paciente(dni(104), nombre("P", "Cuatro"), tiempo_espera(10)).
paciente(dni(105), nombre("P", "Cinco"), tiempo_espera(10)).
paciente(dni(106), nombre("P", "Seis"), tiempo_espera(40)). 

donante(dni(201), nombre("D", "Uno"), dni_paciente(101)).
donante(dni(202), nombre("D", "Dos"), dni_paciente(102)).
donante(dni(203), nombre("D", "Tres"), dni_paciente(103)).
donante(dni(204), nombre("D", "Cuatro"), dni_paciente(104)).
donante(dni(205), nombre("D", "Cinco"), dni_paciente(105)).
donante(dni(206), nombre("D", "Seis"), dni_paciente(106)).

% --- Cadena A (P1, P2, P3) ---
compatibilidad(201, 102, 90.0).
compatibilidad(202, 103, 90.0).
compatibilidad(203, 101, 51.0). 

% --- Cadena B (P4, P5, P6) ---
compatibilidad(204, 105, 80.0).
compatibilidad(205, 106, 80.0).
compatibilidad(206, 104, 52.0). 

% --- Cadena Larga (P1...P6) ---
compatibilidad(201, 104, 70.0). % D1 -> P4
compatibilidad(204, 102, 70.0). % D4 -> P2
compatibilidad(202, 105, 70.0). % D2 -> P5
compatibilidad(205, 103, 70.0). % D5 -> P3
compatibilidad(203, 106, 70.0). % D3 -> P6
compatibilidad(206, 101, 70.0). % D6 -> P1

delta(2.0).


% 1. Obtener la lista de los 6 pacientes.
% ?- lista_pacientes(0, LP).
% 2. Probar 'trasplantes' (debe dar 3 soluciones: Cadena A, Cadena B, Cadena Larga)
% ?- trasplantes(LP, LT).
% Resultado: 3 soluciones (o más, si los sub-grupos se prueban).
% 3. Probar 'cadena_trasplantes_optima'
% ?- cadena_trasplantes_optima(LP, LT_Optima).
% Resultado: Debe devolver la CADENA LARGA de 6 pacientes,
% porque su prioridad mínima (aprox 70) es mayor que
% la de las cadenas cortas (aprox 51 y 52).
