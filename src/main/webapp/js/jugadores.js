function transferirJugador(event) {
    event.preventDefault();

    const idJugador = document.getElementById('jugadoresTransferirId').value;
    const nuevoEquipo = document.getElementById('trasferirJugador').value;

    let url = null;
    if (idJugador != null && nuevoEquipo != null) {
        url = `http://localhost:8081/gestor-eventos-deportivos/jugadores/transferir?jugadorId=${idJugador}&equipoDestino=${nuevoEquipo}`;
    }

    let response = null;

    if (url != null) {
        response = GETData(url, "jugadores.jsp");
        console.log('Respuesta get jugadores: ', response);
    }
}