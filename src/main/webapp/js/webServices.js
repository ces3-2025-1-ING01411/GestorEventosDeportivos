function GETData(url, page) {
    fetch(url, {
        method: 'GET',
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
            // console.log('Respuesta: ', data);
            mostrarAlerta(data.message, data.status, page);
        })
        .catch(err => {
            console.error("Error al actualizar el evento: ", err);
            mostrarAlerta("Ocurrió un error al procesar la solicitud.", "error", page);
        });
}

function POSTData(url, page, createData) {

    fetch(url, {
        method: 'POST',
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(createData)
    })
        .then(response => {
            console.log('response: ', response);
            if (!response.ok) {
                console.error(`Error en la petición: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            // console.log('Respuesta: ', data);
            mostrarAlerta(data.message, data.status, page);
        })
        .catch(err => {
            console.error("Error al crear el registro: ", err);
            mostrarAlerta("Ocurrió un error al procesar la solicitud.", "error", page);
        });
}


// function PUTData(url, page, editData = null) {
//
//     let options = {
//         method: 'PUT',
//         headers: {
//             'Accept': 'application/json'
//         }
//     };
//     console.log('url: ', url);
//     console.log('page: ', page);
//     console.log('editData: ', editData);
//
//     // Si hay datos para editar, los agregamos al cuerpo
//     if (editData) {
//         options.body = JSON.stringify(editData);
//     }
//
//     fetch(url, options)
//         .then(response => {
//             if (!response.ok) {
//                 console.error(`Error en la petición: ${response.status}`);
//             }
//             return response.json();
//         })
//         .then(data => {
//             console.log('Respuesta: ', data);
//             mostrarAlerta(data.message, data.status, page);
//         })
//         .catch(err => {
//             console.error("Error al actualizar el evento: ", err);
//             mostrarAlerta("Ocurrió un error al procesar la solicitud.", "error", page);
//         });
// }