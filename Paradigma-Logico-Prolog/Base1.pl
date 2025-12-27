Base de datos 1
Posee cadena de longitud 8. 

% 8 pacientes y 8 donantes.
paciente(dni(101), nombre("P", "Uno"), tiempo_espera(10)).
paciente(dni(102), nombre("P", "Dos"), tiempo_espera(12)).
paciente(dni(103), nombre("P", "Tres"), tiempo_espera(14)).
paciente(dni(104), nombre("P", "Cuatro"), tiempo_espera(16)).
paciente(dni(105), nombre("P", "Cinco"), tiempo_espera(18)).
paciente(dni(106), nombre("P", "Seis"), tiempo_espera(20)).
paciente(dni(107), nombre("P", "Siete"), tiempo_espera(22)).
paciente(dni(108), nombre("P", "Ocho"), tiempo_espera(24)).

donante(dni(201), nombre("D", "Uno"), dni_paciente(101)).
donante(dni(202), nombre("D", "Dos"), dni_paciente(102)).
donante(dni(203), nombre("D", "Tres"), dni_paciente(103)).
donante(dni(204), nombre("D", "Cuatro"), dni_paciente(104)).
donante(dni(205), nombre("D", "Cinco"), dni_paciente(105)).
donante(dni(206), nombre("D", "Seis"), dni_paciente(106)).
donante(dni(207), nombre("D", "Siete"), dni_paciente(107)).
donante(dni(208), nombre("D", "Ocho"), dni_paciente(108)).

% Compatibilidades (Solo la cadena es compatible)
compatibilidad(201, 102, 90.0). % D1 -> P2
compatibilidad(202, 103, 90.0). % D2 -> P3
compatibilidad(203, 104, 90.0). % D3 -> P4
compatibilidad(204, 105, 90.0). % D4 -> P5
compatibilidad(205, 106, 90.0). % D5 -> P6
compatibilidad(206, 107, 90.0). % D6 -> P7
compatibilidad(207, 108, 90.0). % D7 -> P8
compatibilidad(208, 101, 90.0). % D8 -> P1 (Cierra el ciclo)

delta(2.0).


% 1. Obtener la lista de los 8 pacientes.
% ?- lista_pacientes(0, LP).
% 2. Probar que la encuentra.
% ?- trasplantes(LP, LT).
% Resultado: Debe devolver una única lista LT con 8 trasplantes.
% 3. Probar que una cadena de 7 falla.
% ?- lista_pacientes(12, LP7), trasplantes(LP7, LT).
% Resultado: false. (Porque la cadena no se puede cerrar).
