function limpiarFiltros(event) {
    event.preventDefault();

    //redirigimos sin parámetros en la URL
    window.location.href = "eventos.jsp";
}

function abrirModal(idAccion, valueEvent) {
    console.log(idAccion);
    console.log(valueEvent);
    document.getElementById(idAccion).classList.remove("hidden");

    if (idAccion === 'putEvento') {
        document.getElementById('entradasComprarId').value = valueEvent;
    }

    if (idAccion === 'getTransferir') {
        document.getElementById('jugadoresTransferirId').value = valueEvent;
    }
}

function cerrarModal(idAccion) {
    // console.log(idAccion);
    document.getElementById(idAccion).classList.add("hidden");
}

function mostrarContainer(id) {
    // Ocultar todos los contenedores
    document.getElementById('venderEntradas').classList.add("hidden");
    document.getElementById('actualizarEstado').classList.add("hidden");
    document.getElementById('actualizarEvento').classList.add("hidden");

    // Restablecer los indicadores a blanco
    document.getElementById('divVenderEntradas').classList.remove('bg-violet-600');
    document.getElementById('divVenderEntradas').classList.add('bg-white-600');

    document.getElementById('divActualizarEstado').classList.remove('bg-violet-600');
    document.getElementById('divActualizarEstado').classList.add('bg-white-600');

    document.getElementById('divEditarEvento').classList.remove('bg-violet-600');
    document.getElementById('divEditarEvento').classList.add('bg-white-600');

    // Mostrar solo el contenedor seleccionado y actualizar el indicador
    document.getElementById(id).classList.remove("hidden");

    if (id === 'venderEntradas') {
        document.getElementById('divVenderEntradas').classList.remove('bg-white-600');
        document.getElementById('divVenderEntradas').classList.add('bg-violet-600');
    } else if (id === 'actualizarEstado') {
        document.getElementById('divActualizarEstado').classList.remove('bg-white-600');
        document.getElementById('divActualizarEstado').classList.add('bg-violet-600');
    } else if (id === 'actualizarEvento') {
        document.getElementById('divEditarEvento').classList.remove('bg-white-600');
        document.getElementById('divEditarEvento').classList.add('bg-violet-600');
    }
}


function PUTData(event, action) {
    event.preventDefault();

    const idEvento = document.getElementById('entradasComprarId').value;

    // console.log(idEvento);

    let url;

    if (action === 'venderEntradas') {
        const entradasComprar = document.getElementById('entradasComprar').value;
        // console.log(entradasComprar);
        url = `http://localhost:8081/gestor-eventos-deportivos/eventos/vender-entradas?eventoId=${idEvento}&cantidad=${entradasComprar}`;
    } else if (action === 'actualizarEstado') {
        const estadoActualizar = document.getElementById('estadoActualizar').value;
        // console.log(estadoActualizar);
        url = `http://localhost:8081/gestor-eventos-deportivos/eventos/actualizar-estado?eventoId=${idEvento}&estado=${estadoActualizar}`;
    } else if (action === 'actualizarEvento') {
        url = `http://localhost:8081/gestor-eventos-deportivos/eventos/actualizar-estado?eventoId=${idEvento}`;

    }

    console.log(url);

    fetch(url, {
        method: 'PUT',
        headers: {
            'Accept': 'application/json'
        }
    })
        .then(response => {
            if (!response.ok) {
                console.error(`Error en la petición: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Respuesta: ', data);
            mostrarAlerta(data.message, data.status, "eventos.jsp");
        })
        .catch(err => {
            console.error("Error al actualizar el evento: ", err);
            mostrarAlerta("Ocurrió un error al procesar la solicitud.", "error", "eventos.jsp");
        });

    // window.location.href = "eventos.jsp";
}


function mostrarAlerta(mensaje, tipo, page) {
    const alerta = document.createElement('div');
    alerta.classList.add('custom-alert', tipo === 'success' ? 'alert-success' : 'alert-error');
    alerta.textContent = mensaje;

    document.body.appendChild(alerta);

    setTimeout(() => {
        alerta.remove();
        window.location.href = page;
    }, 3000);
}

function crearEvento(event) {
    event.preventDefault();

    let formData = new FormData(event.target);
    let jsonData = {};

    let equiposSeleccionados = 0;

    // Iteramos sobre los datos del formulario
    formData.forEach((value, key) => {
        if (key === "capacidad" || key === "entradasVendidas") {
            // Convertimos los valores de "capacidad" y "entradasVendidas" a números
            jsonData[key] = Number(value);
        } else if (key === "equiposParticipantes") {
            // Si el campo es "equipos", aseguramos que se guarde como un array
            if (!jsonData[key]) {
                jsonData[key] = [];  // Inicializamos el array si no existe
            }
            jsonData[key].push(Number(value));  // Agregamos el valor como número
            equiposSeleccionados++;
        } else {
            // Para otros campos, los dejamos tal cual
            jsonData[key] = value;
        }
    });

    if (equiposSeleccionados < 2) {
        alert("Debes seleccionar al menos 2 equipos.");
        return;
    }

    console.log('equipos: ', jsonData);
    POSTData("http://localhost:8081/gestor-eventos-deportivos/eventos", "eventos.jsp", jsonData);
}

function actualizarEvento(event) {

}


const styles = document.createElement('style');
styles.innerHTML = `
    .custom-alert {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px;
        color: #fff;
        font-size: 16px;
        border-radius: 5px;
        z-index: 1000;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        animation: fadeIn 0.5s ease-in-out;
    }
    .alert-success {
        background-color: #28a745;
    }
    .alert-error {
        background-color: #dc3545;
    }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
`;
document.head.appendChild(styles);