% --- BASE DE DATOS (Hechos) ---
% paciente(dni(DNI), nombre(Nombre, Apellido), tiempo_espera(Meses)).
paciente(dni(23100200), nombre("Juan", "Martínez"), tiempo_espera(18)).
paciente(dni(37123456), nombre("Ariel", "Lencina"), tiempo_espera(15)).
paciente(dni(27561894), nombre("Ana", "Ramos"), tiempo_espera(8)).
paciente(dni(25450295), nombre("Fernando", "Pérez"), tiempo_espera(20)).

% donante(dni(DNI), nombre(Nombre, Apellido), dni_paciente(DNI_Asociado)).
donante(dni(25200100), nombre("Luis", "Martínez"), dni_paciente(23100200)).
donante(dni(33292500), nombre("Pedro", "Sánchez"), dni_paciente(37123456)).
donante(dni(26854963), nombre("María", "Ramos"), dni_paciente(27561894)).
donante(dni(24700600), nombre("Andrea", "Vera"), dni_paciente(25450295)). 

% compatibilidad(DNI_Donante, DNI_Paciente, Porcentaje).
compatibilidad(25200100, 37123456, 80.0).
compatibilidad(25200100, 27561894, 55.0).
compatibilidad(25200100, 25450295, 75.0).
compatibilidad(33292500, 23100200, 90.0).
compatibilidad(33292500, 25450295, 58.0).
compatibilidad(26854963, 23100200, 60.0).
compatibilidad(26854963, 37123456, 72.0).
compatibilidad(26854963, 27561894, 20.0).
compatibilidad(26854963, 25450295, 65.0).
compatibilidad(24700600, 37123456, 70.0).
compatibilidad(24700600, 27561894, 85.0).

% Constante Delta para la fórmula de prioridad.
delta(2.0).

% --- PREDICADOS AUXILIARES (Generales) ---
% Estos son "herramientas" que nos ayudan a definir reglas más complejas.

% concatenar(Lista1, Lista2, ListaResultado)
% Une dos listas.
concatenar([], Xs, Xs).
concatenar([X|Xs], Ys, [X|Zs]):- concatenar(Xs, Ys, Zs).

% miembro(Elemento, Lista)
% Verifica si un Elemento está en una Lista.
miembro([E|_Xs], E).
miembro([_X|Xs], E):- miembro(Xs, E).
    
% --- PREDICADOS SOLICITADOS (Reglas del TP) ---
% 1. registrado(Donante, Paciente)
% Acorta cuando Donante es el donante REGISTRADO de Paciente (su familiar/conocido).
registrado(donante(DniD, Aux2), paciente(DniP, Aux4)):- 
    donante(dni(DniD), nombre(NomD, ApD), dni_paciente(DniP)),
    paciente(dni(DniP), nombre(NomP, ApP), _),
    string_concat(NomD, " ", Aux1), string_concat(Aux1, ApD, Aux2),
    string_concat(NomP, " ", Aux3), string_concat(Aux3, ApP, Aux4).

% 2. compatible(Donante(DNID,NombreD), Paciente(DNIP, NombreP))
% Acorta si la compatibilidad médica entre Donante y Paciente es >= 50%.
compatible(donante(DniD, NomD), paciente(DniP, NomP)):-
    compatibilidad(DniD, DniP, Porc), Porc >= 50,
    registrado(donante(DniD, NomD), _),
    registrado(_, paciente(DniP, NomP)).

% 3. prioridad(Donante, Paciente, P )
% Calcula la Prioridad (un puntaje) para un trasplante.
% Fórmula: P = Compatibilidad + Delta * (TiempoEsperaEnMeses / 12)
prioridad(donante(DniD, NomD), paciente(DniP, NomP), P):-
    compatible(donante(DniD, NomD), paciente(DniP, NomP)),
    compatibilidad(DniD, DniP, Comp),
    delta(Val),
    paciente(dni(DniP), _, tiempo_espera(TiempE)),
    P is Comp + Val*(TiempE/12).

% 4. lista_paciente(Umbral, ListaPaciente)
% Obtiene la lista de pacientes que esperan MÁS o IGUAL a 'Umbral' meses.
pasaUmbral(Umbral, paciente(DniP, NomP)):-
    paciente(dni(DniP), _, tiempo_espera(TiempE)),
    registrado(_, paciente(DniP, NomP)),
    TiempE >= Umbral.

lista_pacienteAux(Umb, [P|Ps], Aux):-
    pasaUmbral(Umb, P), not(miembro(Aux, P)), !,
    lista_pacienteAux(Umb, Ps, [P|Aux]).
lista_pacienteAux(_Umb, [], _Aux).

lista_pacientes(Umb, Lp):- lista_pacienteAux(Umb, Lp, []).


% 5. transplante(ListaPacientes, ListaTrasplantes)
% Encuentra UNA cadena de trasplantes para la ListaPacientes.
quitar(P_Siguiente, [P_Siguiente | Resto], Resto).
quitar(P_Siguiente, [H | Resto], [H | Pacientes]) :- 
    quitar(P_Siguiente, Resto, Pacientes).    


cadenaAuxiliar([], DonanteActual, PrimerPaciente, [[DonanteActual,PrimerPaciente]]) :-
    compatible(DonanteActual, PrimerPaciente).

cadenaAuxiliar(PacientesDisponibles, DonanteActual, PrimerPaciente, [[DonanteActual, P_Siguiente] | Resto]) :-
    quitar(P_Siguiente, PacientesDisponibles, PacientesQuedan),
    compatible(DonanteActual, P_Siguiente), 
    registrado(D_Siguiente, P_Siguiente), 
    cadenaAuxiliar(PacientesQuedan, D_Siguiente, PrimerPaciente, Resto).


trasplantes([],[]).      
trasplantes([PrimerPaciente | PacientesDisponibles], ListaTrasplantes) :-	
    registrado(D1, PrimerPaciente),
    cadenaAuxiliar(PacientesDisponibles, D1, PrimerPaciente, ListaTrasplantes).


% 6. prioridad_minima(ListaTrasplantes, min) 
% Obtiene la prioridad MÁS BAJA de una ListaTrasplantes.
prioridadMinAux([], Min, Min).
prioridadMinAux([[D,P]|Resto], MinActual, MinFinal):-
    prioridad(D,P,PrioridadNueva),
    PrioridadNueva<MinActual, !,
    prioridadMinAux(Resto, PrioridadNueva, MinFinal).

prioridadMinAux([_|Resto], MinActual, MinFinal) :-
    prioridadMinAux(Resto, MinActual, MinFinal).
    
	    
prioridad_minima([[D,P]|Resto], Min) :-
    prioridad(D, P, PrioridadInicial),
	prioridadMinAux(Resto, PrioridadInicial, Min).

% 7. cadena_trasplantes_optima(ListaPacientes, ListaTrasplantesOptima)
% Busca la cadena que tenga la "mayor prioridad mínima".

% Armo una lista de las cadenas posibles :)
posiblesTrasplantes(Lp, [L|Ls], Aux):- % Lp = Lista pacientes, Ls = ListaTrasplantes, Ls= Resto
    trasplantes(Lp, L), not(miembro(Aux, L)), !,

posiblesTrasplantes(_, [], _).

% Encontrar elemento de la lista con mayor prioridad_minima(E, P)
listaOptima([L], L).

listaOptima([L|Ls], L):- % Lr = Lista con mayor prioridad del resto :)
    listaOptima(Ls, Lr),
    prioridad_minima(L, PriorL),
    prioridad_minima(Lr, PriorLr),
	PriorL > PriorLr.

listaOptima([L|Ls], Lr):-
    listaOptima(Ls, Lr),
    prioridad_minima(L, PriorL),
    prioridad_minima(Lr, PriorLr),
	PriorL < PriorLr.

% Predicado Solicitado
cadena_trasplantes_optima(LPacientes, LOptima):-
    posiblesTrasplantes(LPacientes, LPosibles, []),
    listaOptima(LPosibles, LOptima).


% 8. cadena_trasplantes_completa(Umbral, ListaTrasplantes)
cadena_trasplantes_completa(Umbral, ListaTrasplantesOptima) :-
lista_pacientes(Umbral, ListaPacientes),
cadena_trasplantes_optima(ListaPacientes, ListaTrasplantesOptima).
