#!/bin/bash

cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Feedback</title>
</head>
<body>
    <h1>Formulario de Feedback</h1>

    <form action="/feedback" method="POST">
        <label>Nombre:</label><br>
        <input type="text" name="Nombre" required><br><br>

        <label>Sugerencia:</label><br>
        <textarea name="Sugerencia" required></textarea><br><br>

        <label>Ubicación:</label><br>
        <input type="text" name="Ubicacion"><br><br>

        <label>Platillo Favorito:</label><br>
        <input type="text" name="PlatilloFavorito"><br><br>

        <label>Fecha de Cumpleaños:</label><br>
        <input type="date" name="FechaCumpleanos"><br><br>

        <label>Teléfono:</label><br>
        <input type="text" name="Telefono"><br><br>

        <label>Email:</label><br>
        <input type="email" name="Email"><br><br>

        <button type="submit">Enviar</button>
    </form>
</body>
</html>
EOF
