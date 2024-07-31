<%@ page import="java.sql.*, java.util.ArrayList, com.DatabaseConnector" %>
<%@ page import="com.Marca" %>

<html>
<head>
    <title>Inventari de Màquines i Sistemes</title>
    
    <link rel="stylesheet" type="text/css" href="format.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="icon" type="image/x-icon" href="favicon.ico" />
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    
    
    
<%------ FUNCIONS --------------------------------------------------------------------------------------------------------------%>

    <script>
    
        // Funció per desar canvis del desplegable 
        function guardarCanvisSelect(selectElement) {
            var id = $(selectElement).closest('tr').data('id');
            var columnName = "Marca";
            var newValue = $(selectElement).val();
            console.log("ID: " + id);
            console.log("Nom de la columna: " + columnName);
            console.log("Nou valor: " + newValue);
            
            $.ajax({
                type: 'POST',
                url: 'guardar_cambios.jsp',
                data: {
                    id: id,
                    columnName: columnName,
                    newValue: newValue
                },
                success: function(response) {
                    console.log(response); 
                },
                error: function(xhr, status, error) {
                    console.error("Error en la sol·licitud AJAX:", error);
                }
            });
        }
        
        // Funció per comparar adreces IP
        function compararIPs(ip1, ip2) {
            var parts1 = ip1.split(".");
            var parts2 = ip2.split(".");
            
            for (var i = 0; i < 4; i++) {
                var num1 = parseInt(parts1[i], 10);
                var num2 = parseInt(parts2[i], 10);
                
                if (num1 < num2) {
                    return -1;
                } else if (num1 > num2) {
                    return 1;
                }
            }
            
            return 0;
        }

        // Funció per ordenar la taula
        $(document).ready(function() {
            
            function ordenarTaula(columna, ordre) {
                var taula, files, canvi, i, shouldSwitch;
                taula = document.getElementById("tablaDatos");
                canvi = true;

                while (canvi) {
                    canvi = false;
                    files = taula.rows;

                    for (i = 1; i < files.length - 1; i++) {
                        shouldSwitch = false;
                        var x = files[i].getElementsByTagName("TD")[columna];
                        var y = files[i + 1].getElementsByTagName("TD")[columna];

                        var contingutX = x.innerHTML.trim().toLowerCase(); // per a que no diferencii maj i min
                        var contingutY = y.innerHTML.trim().toLowerCase(); 

                        // Comprovar si els valors són enters
                        var esEnterX = /^\d+$/.test(contingutX);
                        var esEnterY = /^\d+$/.test(contingutY);

                        if (esEnterX && esEnterY) { 
                            var intX = parseInt(contingutX);
                            var intY = parseInt(contingutY);

                            if (ordre === 'asc') {
                                if (intX > intY) {
                                    shouldSwitch = true;
                                    break;
                                }
                            } else {
                                if (intX < intY) {
                                    shouldSwitch = true;
                                    break;
                                }
                            }
                        } else if (/^\d+\.\d+\.\d+\.\d+$/.test(contingutX) && /^\d+\.\d+\.\d+\.\d+$/.test(contingutY)) { // Si no són enters, comprovar si són adreces IP
                            if (ordre === 'asc') {
                                if (compararIPs(contingutX, contingutY) > 0) {
                                    shouldSwitch = true;
                                    break;
                                }
                            } else {
                                if (compararIPs(contingutX, contingutY) < 0) {
                                    shouldSwitch = true;
                                    break;
                                }
                            }
                        } else { // Si no són enters ni adreces IP, comparar com a dates
                            var dataX = parseData(contingutX);
                            var dataY = parseData(contingutY);

                            if (ordre === 'asc') {
                                if (dataX > dataY) {
                                    shouldSwitch = true;
                                    break;
                                }
                            } else {
                                if (dataX < dataY) {
                                    shouldSwitch = true;
                                    break;
                                }
                            }
                        }
                    }

                    if (shouldSwitch) {
                        files[i].parentNode.insertBefore(files[i + 1], files[i]);
                        canvi = true;
                    }
                }
            }

            // Funció per analitzar dates
            function parseData(data) {
                var parts = data.split("/");
                return parts[2] + parts[1] + parts[0]; 
            }

            // Ordenar en fer clic al botó
            $(".ordenar-btn").on("click", function() {
                var columnIndex = $(this).data("column-index");
                var ordre = $(this).data("order");
                ordenarTaula(columnIndex, ordre);
            });

            // Editar cel·les amb doble clic 
            $("td").on("dblclick", function(event) {
		    var columnName = $(this).data("column"); 
		    
		    
		    // Llista de columnes no editables
		    var nonEditableColumns = ["Marca", "Button", "PDF"];
		    
		    if (!nonEditableColumns.includes(columnName)) { 
		        event.stopPropagation();
		        var cell = $(this)[0];
		        ferEditable(cell);
		    }
			});
            

            // Fer una cel·la editable 
            function ferEditable(cell) {
                cell.contentEditable = true;
                cell.setAttribute('data-original-value', cell.innerHTML.trim());
                cell.focus();
            }

            // Clic en Enter per desar canvis
            $("table").on("keydown", "td[contenteditable='true']", function(event) {
                if (event.key === 'Enter') {
                    var cell = $(this)[0];
                    var newValue = cell.innerText.trim();
                    var originalValue = cell.getAttribute('data-original-value');
                    if (newValue !== originalValue) {
                        var columnName = $(cell).data('column');
                        if (columnName) { // Verificar que columnName no es undefined
                            guardarCanvis(cell, newValue);
                            if (columnName.includes("Serveis Recerca") ||
                            	columnName.includes("CLS") ||
                            	columnName.includes("CMP") ||
                            	columnName.includes("IB") ||
                            	columnName.includes("SLB Pública") ||
                                columnName.includes("SLB Privada") ||
                                columnName.includes("SLB Back") ||
                                columnName.includes("Backup") ||
                                columnName.includes("GlusterFS") ||
                                columnName.includes("Proxmox-CoroSync") ||
                                columnName.includes("Proxmox-VE") ||
                                columnName.includes("Proxmox-Hosts") ||
                                columnName.includes("VMotion") ||
                                columnName.includes("Pública Lab Recerca") ||
                                columnName.includes("Pública FW") ||
                                columnName.includes("Cluster economiques") ||
                                columnName.includes("Manager Network CEXS") ||
                                columnName.includes("interna Pulsar") ||
                                columnName.includes("gladmin") ||
                                columnName.includes("Kvm") ||
                                columnName.includes("Xarxa servei cluster Brain") ||
                                columnName.includes("Lvl2 HPC CNS Brain2") ||
                                columnName.includes("Lvl2 HPC CNS Brain") ||
                                columnName.includes("Xarxa sala màquines PRBB") ||
                                columnName.includes("Xarxa microscopi PRBB") ||
                                columnName.includes("Consoles Administració PRBB") ||
                                columnName.includes("ccconssit") ||
                                columnName.includes("Pròxima VLAN per docker swarm") ||
                                columnName.includes("Xarxa altres serveis") ||
                                columnName.includes("Xarxa BastioCM") ||
                                columnName.includes("Xarxa cmsrvsbastio") ||
                                columnName.includes("Xarxa BastioCC") ||
                                columnName.includes("Xarxa CCsrvBastio")) {
                                verificarDuplicados(columnName); // Verificar duplicats
                            }
                        } else {
                            console.error("El nom de la columna no s'ha definit correctament.");
                        }
                    }
                    cell.blur();
                    event.preventDefault();
                }
            });
            

            // Funció per desar els canvis (de les altres columnes)
            function guardarCanvis(cell, newValue) {
                var id = $(cell).closest('tr').data('id');
                var columnName = $(cell).data('column');

                if (columnName) { // Verificar que columnName no es undefined
                    guardarCanvisBD(id, columnName, newValue);
                } else {
                    console.error("El nom de la columna no s'ha definit correctament.");
                }
            }

            // Funció per desar canvis a la base de dades
            function guardarCanvisBD(id, columnName, newValue) {
                console.log("ID: " + id);
                console.log("Nom de la columna: " + columnName);
                console.log("Nou valor: " + newValue);
                
                $.ajax({
                    type: 'POST',
                    url: 'guardar_cambios.jsp',
                    data: {
                        id: id,
                        columnName: columnName,
                        newValue: newValue.trim()
                    },
                    success: function(response) {
                        console.log(response); 
                    },
                    error: function(xhr, status, error) {
                        console.error("Error en la sol·licitud AJAX:", error);
                    }
                });
            }
            
            // Reemplaçar valors NULL per '-'
            $("table td").each(function() {
                if ($(this).text().trim() === 'null') {
                    $(this).text('-');
                }
            });
        });

       	// Alerta d'adreces IP duplicades (posa tots els valors al 1r array i si ja esta el posa al 2n) 
       	function verificarDuplicados(columna) {
       	     var valores = [];
       	     var duplicados = [];
       	     var columnaIndex = $("th:contains('" + columna + "')").index();

       	     $("#tablaDatos tbody tr").each(function() {
       	         var valor = $(this).find("td:eq(" + columnaIndex + ")").text().trim();
       	         if (valor !== '' && valor !== 'null' && valor !== '-') {
       	             if (valores.indexOf(valor) !== -1) {
       	                 if (duplicados.indexOf(valor) === -1) {
       	                     duplicados.push(valor);
       	                 }
       	             } else {
       	                 valores.push(valor);
       	             }
       	         }
       	     });

       	     if (duplicados.length > 0) {
       	         var mensaje = "S'han trobat valors duplicats a la columna '" + columna + "':\n\n";
       	         mensaje += duplicados.join(", ");
       	         $('#modalContent').html(mensaje);
                 $('#myModal').modal('show');
       	     }
       	}
       	
       	function mostrarModalEliminar(id, nom) {
       	    
       	    var mensaje = "Estàs segur d'eliminar aquesta fila amb nom: " + nom + "?";
       	    $("#myModal2 .modal-body").html(mensaje);

       	    // Mostrar el modal
       	    $("#myModal2").modal('show');

       	    
       	    $("#confirmarEliminar").off().on("click", function() {
       	        eliminarFila(id);
       	        $("#myModal2").modal('hide');
       	    });
       	}
       	
       	// funció per adjuntar arxius
       	function uploadFile(input, id) {
       	    const file = input.files[0];
       	    if (file) {
       	        const formData = new FormData();
       	        formData.append("file", file);
       	        formData.append("id", id);

       	        fetch('uploadPDF', {
       	            method: 'POST',
       	            body: formData
       	        }).then(response => response.json())
       	        .then(data => {
       	            if (data.success) {
       	                alert("Fitxer adjuntat correctament");
       	                location.reload();
       	            } else {
       	                alert("Error al adjuntar el fitxer: " + data.message);
       	            }
       	        }).catch(error => {
       	            console.error('Error:', error);
       	            alert("Error al adjuntar el fitxer: " + error.message);
       	        });
       	    }
       	}

       	// funció per eliminar arxius
       	function eliminarPDF(id) {
       	    fetch('eliminarPDF?id=' + id, {
       	        method: 'DELETE'
       	    }).then(response => {
       	        if (response.ok) {
       	            alert("PDF eliminat correctament");
       	            
       	            var pdfContainer = document.querySelector('tr[data-id="' + id + '"] td[data-column="PDF"]');
       	            if (pdfContainer) {
       	                
       	                pdfContainer.innerHTML = '<img src="clip.ico" alt="PDF" width="40" height="40" class="adjuntar-clip" data-id="' + id + '" />';
       	                console.log('Nova icona de clip agregada al DOM');

       	                
       	                var newClipIcon = pdfContainer.querySelector('img.adjuntar-clip');
       	                if (newClipIcon) {
       	                    
       	                    newClipIcon.addEventListener('click', function() {
       	                        var fileInput = document.getElementById('fileInput-' + id);
       	                        if (!fileInput) {
       	                            
       	                            fileInput = document.createElement('input');
       	                            fileInput.type = 'file';
       	                            fileInput.id = 'fileInput-' + id;
       	                            fileInput.style.display = 'none';
       	                            fileInput.addEventListener('change', function() {
       	                                uploadFile(this, id);
       	                            });
       	                            document.body.appendChild(fileInput);
       	                            console.log('Input creat i afegit al DOM per a ID:', id);
       	                        }
       	                        fileInput.click();
       	                    });
       	                    console.log('Event listener afegit a la nova icona de clip');
       	                } else {
       	                    console.error('Nova icona de clip no trobada');
       	                }
       	            }
       	        } else {
       	            alert("No s'ha pogut eliminar el PDF");
       	        }
       	    }).catch(error => {
       	        console.error('Error:', error);
       	        alert("Error al intentar eliminar el PDF");
       	    });
       	}

       	document.addEventListener('DOMContentLoaded', function() {
       	    document.querySelectorAll('.adjuntar-clip').forEach(function(clip) {
       	        clip.addEventListener('click', function() {
       	            var id = this.getAttribute('data-id');
       	            var fileInput = document.getElementById('fileInput-' + id);
       	            if (fileInput) {
       	                fileInput.click();
       	            } else {
       	                console.error('File input not found for ID:', id);
       	            }
       	        });
       	    });
       	    document.querySelectorAll('.btn-modificar').forEach(function(modificar) {
       	        modificar.addEventListener('click', function() {
       	            var id = this.getAttribute('data-id');
       	            var fileInput = document.getElementById('fileInput-' + id);
       	            if (fileInput) {
       	                fileInput.click();
       	            } else {
       	                console.error('File input not found for ID:', id);
       	            }
       	        });
       	    });
       	    document.querySelectorAll('.btn-eliminar').forEach(function(btn) {
       	        btn.addEventListener('click', function() {
       	            var id = this.getAttribute('data-id');
       	            if (confirm("¿Estàs segur que vols eliminar aquest PDF?")) {
       	                eliminarPDF(id);
       	            }
       	        });
       	    });
       	});
         
     </script>
</head>
</html>




<%---- TAULA I DADES -------------------------------------------------------------------------------------------------------------------%>

</head>
<body>
<%
    // Secció de connexió i consulta a la base de dades
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        connection = DatabaseConnector.getConnection();
        statement = connection.createStatement();
        String query = "SELECT m.*, MARCA.nom_marca AS NombreMarca " +
                "FROM MAQUINARI m " +
                "JOIN MARCA ON m.Marca = MARCA.id_marca " +
                "ORDER BY m.id ASC";
        resultSet = statement.executeQuery(query);

        // Obtenir dades
        ResultSetMetaData metaData = resultSet.getMetaData();
        int columnCount = metaData.getColumnCount();
        String[] columnNames = new String[columnCount];

        for (int i = 0; i < columnCount; i++) {
            columnNames[i] = metaData.getColumnName(i + 1);
        }

        // Consulta SQL per obtenir les marques disponibles
        ArrayList<Marca> marques = DatabaseConnector.getMarcasDisponibles();
%>

<table id="tablaDatos">
    <thead>
        <tr>
            <% for (int i = 0; i < columnCount; i++) { %>
                <th data-column="<%= columnNames[i] %>">
                    <% if (!columnNames[i].equals("Button") && !columnNames[i].equals("PDF")) { %>
                        <%= columnNames[i] %>
                        <button class="ordenar-btn" data-column-index="<%= i %>" data-order="asc">&#9660;</button>
                        <button class="ordenar-btn" data-column-index="<%= i %>" data-order="desc">&#9650;</button>
                    <% } else { %>
                        <%= columnNames[i] %>
                    <% } %>
                </th>
            <% } %>
        </tr>
    </thead>
    <tbody>
        <% while (resultSet.next()) { %>
            <tr data-id="<%= resultSet.getString("id") %>">
                <% for (int i = 1; i <= columnCount; i++) { %>
                    <% if (metaData.getColumnName(i).equals("Marca")) { %>
                        <td data-column="Marca">
                            <select onchange="guardarCanvisSelect(this)">
                                <% for (Marca marca : marques) { %>
                                    <option value="<%= marca.getId() %>" <% if (marca.getNombre().equals(resultSet.getString("NombreMarca"))) { %> selected <% } %> ><%= marca.getNombre() %></option> 
                                <% } %>
                            </select>
                        </td>
                    <% } else if (metaData.getColumnName(i).equals("Button")) { %>
                        <td data-column="Button">
                            <button class="btn btn-danger btn-sm" onclick="mostrarModalEliminar('<%= resultSet.getString("id") %>', '<%= resultSet.getString("Nom") %>')">Eliminar fila</button>
                        </td> 
                    <% } else if (metaData.getColumnName(i).equals("PDF")) { %>
                        <td data-column="PDF">
                            <% if (resultSet.getString("PDF") != null) { %>
                                <div>
                                    <a href="displayPDF?id=<%= resultSet.getString("id") %>" target="_blank">
                                        <img src="pdf.ico" alt="PDF" width="50" height="50" />
                                    </a>
                                    <div style="margin-top: 5px;">
                                        <button class="btn btn-info btn-sm btn-modificar" data-id="<%= resultSet.getString("id") %>">Modificar</button>
                                        <button class="btn btn-danger btn-sm" onclick="eliminarPDF('<%= resultSet.getString("id") %>')">Eliminar</button>
                                    </div>
                                </div>
                            <% } else { %>
                                <img src="clip.ico" alt="PDF" width="40" height="40" class="adjuntar-clip" data-id="<%= resultSet.getString("id") %>" />
                            <% } %>
                            <input type="file" id="fileInput-<%= resultSet.getString("id") %>" style="display: none;" onchange="uploadFile(this, '<%= resultSet.getString("id") %>');" />
                        </td>
                    <% } else { %>
                        <td data-column="<%= metaData.getColumnName(i) %>"><%= resultSet.getString(i) %></td>
                    <% } %>
                <% } %>
            </tr>
        <% } %>
    </tbody>
</table>



<button id="afegirFila" class="btn btn-info">
    <span>Afegir fila</span>
    <span style="font-size: 20px; margin-left: 5px;">+</span>
</button>




<!------- POP UP D'ALERTES ----------------------------------------------------------------------------------------------------------------------------------->

<div class="modal fade" id="myModal" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">Alerta d'adreces IP duplicades</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body" id="modalContent">
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Tancar</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="myModal2" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">Estàs segur d'eliminar aquesta fila?</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>
      <div class="modal-body" id="modalContent2">
        Estàs segur d'eliminar aquesta fila?
      </div>
      <div class="modal-footer">
        <button id="confirmarEliminar" type="button" class="btn btn-danger">Eliminar</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Tancar</button>
      </div>
    </div>
  </div>
</div>



<%---- ERRORS I TANCAMENT DE CONNEXIONS -----------------------------------------------------------------------------------------------------------%>

<%
} catch (SQLException e) {
    // En cas d'error
    e.printStackTrace();
} finally {
    try {
        // Tancar connexions i recursos
        if (resultSet != null) resultSet.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>


<%---- AFEGIR I ELIMINAR FILES ---------------------------------------------------------------------------------------------------------------------%>

<script>
$(document).ready(function() {
    $("#afegirFila").click(function() {
        var lastId = parseInt($("#tablaDatos tbody tr:last").attr("data-id")) || 0; 
        var newId = lastId + 1;
        var newRow = $("<tr data-id='" + newId + "'></tr>");
        var columnCount = $("#tablaDatos thead th").length;

        for (var i = 0; i < columnCount; i++) { 
            var columnName = $("#tablaDatos thead th").eq(i).data('column'); 
            var newCell;
            if (columnName === "Marca") {
                newCell = $("<td data-column='Marca'><select onchange='guardarCanvisSelect(this)'></select></td>");
                
                var selectOptions = $("#tablaDatos tbody tr:first select option");
                selectOptions.each(function() {
                    var option = $(this).clone();
                    newCell.find("select").append(option);
                });
                newCell.find("select").val('6'); 
            } else if (columnName === "Button") {
                newCell = $("<td data-column='Button'><button class='btn btn-danger btn-sm' onclick='mostrarModalEliminar(" + newId + ")'>Eliminar fila</button></td>");
            } else if (columnName === "PDF") {
                newCell = $("<td data-column='PDF'><img src='clip.ico' alt='PDF' width='40' height='40' /></td>");
            } else {
                newCell = $("<td contenteditable='true' data-column='" + columnName + "'><br><br></td>");
            }
            newRow.append(newCell);
        }

        $("#tablaDatos tbody").append(newRow);

        // Enviar la nova fila a la base de dades
        guardarNovaFila(newId, 6); // Valor '6' a la columna 'Marca' que correspon a '-'
    });

    // Guardar la nova fila a la base de dades
    function guardarNovaFila(id, marcaValue) {
        $.ajax({
            type: 'POST',
            url: 'guardar_nueva_fila.jsp', 
            data: {
                id: id,
                marca: marcaValue // Passar el valor de la columna 'Marca'
            },
            success: function(response) {
                console.log("Fila guardada exitosament:", response);
            },
            error: function(xhr, status, error) {
                console.error("Error en la sol·licitud AJAX:", error);
            }
        });
    }

    // Mostrar el modal de confirmació per eliminar una fila
    window.mostrarModalEliminar = function(id, nom) {
        $("#confirmarEliminar").data("id", id);
        $("#modalContent2").html("Estàs segur d'eliminar aquesta fila amb nom: " + nom + "?");
        $("#myModal2").modal('show');
    }

    // Eliminar una fila de la base de dades
    $("#confirmarEliminar").click(function() {
        var id = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: 'eliminar_fila.jsp',
            data: { id: id },
            success: function(response) {
                console.log("Fila eliminada exitosament:", response);
                // Eliminar la fila de la taula
                $("#tablaDatos tbody tr[data-id='" + id + "']").remove();
                $("#myModal2").modal('hide');
            },
            error: function(xhr, status, error) {
                console.error("Error en la sol·licitud AJAX:", error);
            }
        });
    });
});
</script>


</body>
</html>