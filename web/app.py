import os
from flask import Flask, jsonify, render_template, abort
import mysql.connector

app = Flask(__name__)
app.config['TEMPLATES_AUTO_RELOAD'] = True # Fuerza a Flask a que recargue las plantillas HTML en cada request (recarga de página); muy útil para desarrollo

# Configuración de conexión desde variables de entorno (.env)
DB_HOST = os.getenv('MYSQL_HOST')
DB_PORT = os.getenv('MYSQL_PORT')
DB_USER = os.getenv('MYSQL_USER')
DB_PASSWORD = os.getenv('MYSQL_PASSWORD')
DB_NAME = os.getenv('MYSQL_DATABASE')

# Fuerza la cabecer UTF-8 en todas las respuestas HTML (para evitar errores)
@app.after_request
def after_request(response):
    if response.content_type == 'text/html; charset=utf-8':
        response.headers['Content-Type'] = 'text/html; charset=utf-8'
    elif response.content_type.startswith('text/html'):
        response.headers['Content-Type'] = 'text/html; charset=utf-8'
    return response

def get_db_connection():
    """
        Establece y devuelve una conexión a MySQL.
    """
    try:
        conn = mysql.connector.connect( # Se usa mysql.connector para establecer la conexión con MySQL y se le pasa todo lo necesario
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            buffered=True,
            charset='utf8mb4', # Para evitar errores de codificación
            autocommit=True,
            use_unicode=True
        )
        return conn # Devuelve la conexión establecida con la bbdd
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        print(f"Error al conectar con la base de datos: {err}")
        return None # No se devuelve nada

@app.route('/')
def index():
    """
        Página principal con dashboard de estadísticas

        URL: localhost:8000/
    """
    conn = get_db_connection() # Primero, se conecta a la base de datos
    if not conn: # Si no se devuelve ninguna conexión, se devuelve un error
        return render_template('error.html', message="Error de conexión con la base de datos"), 500
    
    try:
        cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios
        
        cursor.execute("SELECT * FROM v_estadisticas_instituto") # Se ejecuta un select se la vista que devuelve todas las estadísticas del instituto (corresponde al primer bloque, resumen general)
        estadisticas = cursor.fetchone() # Se hace un fetch para obtener la primera fila
        
        # Obtener cursos con disponibilidad
        cursor.execute("SELECT * FROM v_cursos_disponibilidad LIMIT 10") # Se ejecuta un select para ver los cursos con más disponibilidad (donde hay menos alumnos) y se limita la salida a los 10 primeros
        cursos_disponibles = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
        cursor.execute("""
            SELECT 
                fp.nombre_familia,
                COUNT(DISTINCT c.id_curso) as total_cursos,
                SUM(c.alumnos_matriculados) as total_alumnos
            FROM familias_profesionales fp
            LEFT JOIN cursos c ON fp.id_familia = c.id_familia
            GROUP BY fp.id_familia, fp.nombre_familia
            ORDER BY fp.nombre_familia
        """) # Se obtienen todas las familias profesionales y el conteo de alumnos
        familias = cursor.fetchall() # Se hace un fetch para obtener todas las filas

        cursor.execute("SELECT id_curso, nombre_curso FROM cursos ORDER BY nombre_curso") # Se obtienen todos los cursos para luego mostrarlos en el menú
        cursos_menu = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        print(f"Error en la consulta: {err}")
        return render_template('error.html', message="Error al cargar los datos"), 500
    finally:
        cursor.close() # Se cierra el cursor siempre al acabar
        conn.close() # Se cierra la conexión siempre al acabar
    
    return render_template( # Con los datos obtenidos, se renderiza la plantilla 'dashboard.html' que es donde se mostrará toda esta información y se le envían los datos
        'dashboard.html',
        estadisticas=estadisticas,
        cursos_disponibles=cursos_disponibles,
        familias=familias,
        cursos_menu=cursos_menu
    )

@app.route('/alumnos')
def listado_general():
    """
        Listado general de todos los alumnos

        URL: localhost:8000/alumnos
    """
    conn = get_db_connection() # Primero, se conecta a la base de datos
    if not conn: # Si no se devuelve ninguna conexión, se devuelve un error
        return render_template('error.html', message="Error de conexión con la base de datos"), 500
    
    try:
        cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios
        
        cursor.execute("""
            SELECT a.dni, a.nombre, a.apellidos, a.telefono, a.email, 
                   a.fecha_matricula, a.id_curso,
                   c.nombre_curso, fp.nombre_familia
            FROM alumnos a
            INNER JOIN cursos c ON a.id_curso = c.id_curso
            INNER JOIN familias_profesionales fp ON c.id_familia = fp.id_familia
            WHERE a.activo = TRUE
            ORDER BY a.apellidos, a.nombre
        """) # Se obtienen todos los alumnos activos
        alumnos_data = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
        cursor.execute("SELECT id_curso, nombre_curso FROM cursos ORDER BY nombre_curso") # Se obtienen los cursos para el menú
        cursos_menu = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        print(f"Error en la consulta: {err}")
        return render_template('error.html', message="Error al cargar los alumnos"), 500
    finally:
        cursor.close() # Se cierra el cursor siempre al acabar
        conn.close() # Se cierra la conexión siempre al acabar
    
    return render_template( # Se renderiza la plantilla html y se le envían los datos pertinentes
        'alumnos.html', 
        alumnos=alumnos_data, 
        cursos_menu=cursos_menu,
        titulo="Listado General de Alumnos"
    )


@app.route('/curso/<int:curso_id>')
def listado_por_curso(curso_id):
    """
        Listado de alumnos por curso específico
        
        URL: localhost:8000/curso/1    
    """
    conn = get_db_connection() # Primero, se conecta a la base de datos
    if not conn: # Si no se devuelve ninguna conexión, se devuelve un error
        return render_template('error.html', message="Error de conexión con la base de datos"), 500
    
    try:
        cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios
        
        cursor.execute("""
            SELECT c.id_curso, c.nombre_curso, c.alumnos_matriculados, 
                   c.capacidad_maxima, fp.nombre_familia
            FROM cursos c
            INNER JOIN familias_profesionales fp ON c.id_familia = fp.id_familia
            WHERE c.id_curso = %s
        """, (curso_id,)) # Se verifica si el curso existe y se obtiene su información
        curso_info = cursor.fetchone() # Se hace un fetch para obtener la primera fila
        
        if not curso_info: # Si no se ha obtenido nada en la consulta anterior, se aborta
            return abort(404)

        cursor.execute("""
            SELECT a.dni, a.nombre, a.apellidos, a.telefono, 
                   a.email, a.fecha_matricula
            FROM alumnos a
            WHERE a.id_curso = %s AND a.activo = TRUE
            ORDER BY a.apellidos, a.nombre
        """, (curso_id,)) # Se obtienen los alumnos del curso
        alumnos_data = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
        cursor.execute("SELECT id_curso, nombre_curso FROM cursos ORDER BY nombre_curso") # S eobtienen los cursos para mostrar el menú
        cursos_menu = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        print(f"Error en la consulta: {err}")
        return render_template('error.html', message="Error al cargar el curso"), 500
    finally:
        cursor.close() # Se cierra el cursor siempre al acabar
        conn.close() # Se cierra la conexión siempre al acabar
    
    return render_template( # Se renderiza la plantilla html y se le envían los datos pertinentes
        'curso_detalle.html', 
        curso=curso_info,
        alumnos=alumnos_data, 
        cursos_menu=cursos_menu
    )

@app.route('/familias')
def listado_familias():
    """
        Listado de familias profesionales con sus cursos

        URL: localhost:8000/familias    
    """
    conn = get_db_connection() # Primero, se conecta a la base de datos
    if not conn: # Si no se devuelve ninguna conexión, se devuelve un error
        return render_template('error.html', message="Error de conexión con la base de datos"), 500
    
    try:
        cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios

        cursor.execute("""
            SELECT 
                fp.id_familia,
                fp.nombre_familia,
                fp.descripcion,
                COUNT(c.id_curso) as total_cursos,
                SUM(c.alumnos_matriculados) as total_alumnos,
                SUM(c.capacidad_maxima) as capacidad_total
            FROM familias_profesionales fp
            LEFT JOIN cursos c ON fp.id_familia = c.id_familia
            GROUP BY fp.id_familia, fp.nombre_familia, fp.descripcion
            ORDER BY fp.nombre_familia
        """) # Se btienen las familias con sus cursos
        familias = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
        cursor.execute("SELECT id_curso, nombre_curso FROM cursos ORDER BY nombre_curso")
        cursos_menu = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        print(f"Error en la consulta: {err}")
        return render_template('error.html', message="Error al cargar las familias"), 500
    finally:
        cursor.close() # Se cierra el cursor siempre al acabar
        conn.close() # Se cierra la conexión siempre al acabar
    
    return render_template( # Se devuelve la plantilla renderizada y los datos correspondientes
        'familias.html', 
        familias=familias,
        cursos_menu=cursos_menu
    )

@app.route('/api/estadisticas')
def api_estadisticas():
    """
        API: Estadísticas generales del instituto

        URL: localhost:8000/api/estadisticas    
    """
    conn = get_db_connection() # Primero, se conecta a la base de datos
    if not conn: # Si no se devuelve ninguna conexión, se devuelve un error
        return jsonify({"error": "Error de conexión"}), 500
    
    try:
        cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios

        cursor.execute("SELECT * FROM v_estadisticas_instituto") # Se obtienen todas las estadísticas mediante el uso de la vista
        estadisticas = cursor.fetchone() # Se hace un fetch para obtener la primera fila

        return jsonify(estadisticas)
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        return jsonify({"error": str(err)}), 500
    finally:
        cursor.close() # Se cierra el cursor siempre al acabar
        conn.close() # Se cierra la conexión siempre al acabar

@app.route('/api/alumnos')
def api_alumnos():
    """
        API: Listado de todos los alumnos que proporciona un JSON

        URL: localhost:8000/api/alumnos
    """
    conn = get_db_connection() # Primero, se conecta a la base de datos
    if not conn: # Si no se devuelve ninguna conexión, se devuelve un error
        return jsonify({"error": "Error de conexión"}), 500
    
    try:
        cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios
        
        cursor.execute("SELECT * FROM v_listado_general_alumnos WHERE activo = TRUE") # Se hace una consulta con el cursor
        alumnos = cursor.fetchall() # Se hace un fetch para obtener todas las filas

        return jsonify(alumnos) # Se muestra un json por web para poder copiarlo y sacar los datos
    except mysql.connector.Error as err: # Manejo de errores durante la conexión
        return jsonify({"error": str(err)}), 500
    finally:
        cursor.close() # Se cierra el cursor siempre al acabar
        conn.close() # Se cierra la conexión siempre al acabar

@app.errorhandler(404)
def not_found(error):
    """
        Maneja los errores
    """
    conn = get_db_connection() # Se obtiene la conexión a la bbdd
    cursos_menu = [] # Se crea un diccionario vacío
    if conn:
        try:
            cursor = conn.cursor(dictionary=True) # Se crea un cursor para interactuar con la base de datos y hacer consultas, True devuelve las filas como diccionarios

            cursor.execute("SELECT id_curso, nombre_curso FROM cursos ORDER BY nombre_curso") # Se hace una consulta con el cursor
            cursos_menu = cursor.fetchall() # Se hace un fetch para obtener todas las filas
        except: # Si hay excepción, no se hace nada
            pass
        finally:
            cursor.close() # Se cierra el cursor siempre al acabar
            conn.close() # Se cierra la conexión siempre al acabar
    
    return render_template( # Se devuelve el html de error renderizado con sus datos pertinentes
        'error.html', 
        message="Página no encontrada",
        cursos_menu=cursos_menu
    ), 404

if __name__ == '__main__': # Inicialización de la aplicación
    app.run(host='0.0.0.0', port=5000, debug=True)