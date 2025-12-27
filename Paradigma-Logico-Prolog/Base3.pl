Base de datos 3
Se busca probar que no se puede cerrar un ciclo de 4,  falla. 
Sí hay ciclo de 3. 

paciente(dni(101), nombre("P", "Uno"), tiempo_espera(10)).
paciente(dni(102), nombre("P", "Dos"), tiempo_espera(10)).
paciente(dni(103), nombre("P", "Tres"), tiempo_espera(10)).
paciente(dni(104), nombre("P", "Cuatro"), tiempo_espera(10)).

donante(dni(201), nombre("D", "Uno"), dni_paciente(101)).
donante(dni(202), nombre("D", "Dos"), dni_paciente(102)).
donante(dni(203), nombre("D", "Tres"), dni_paciente(103)).
donante(dni(204), nombre("D", "Cuatro"), dni_paciente(104)).

compatibilidad(201, 102, 90.0). % D1 -> P2
compatibilidad(202, 103, 90.0). % D2 -> P3
compatibilidad(203, 104, 90.0). % D3 -> P4
compatibilidad(203, 101, 80.0). 

delta(2.0).

% 1. Obtener la lista de los 4 pacientes.
% ?- lista_pacientes(0, LP).
% 2. Probar 'trasplantes' con los 4.
% ?- trasplantes(LP, LT).
% Resultado: false. (Porque D1 es el primero, y la única
% cadena que empieza con D1 no se puede cerrar).
% 3. Probar 'cadena_trasplantes_optima' con los 4.
% ?- cadena_trasplantes_optima(LP, LT).
% Resultado: false.
% 4. Probar que la de 3 sí existe (depende del orden).
% ?- LP = [paciente(dni(101), _, _), paciente(dni(102), _, _), paciente(dni(103), _, _)], trasplantes(LP, LT).
% Resultado: Debe encontrar la cadena de 3.
