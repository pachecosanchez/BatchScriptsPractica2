
@echo off
setlocal enabledelayedexpansion
title Sistema de Registro e Inicio de Sesión

:menu_principal
cls
echo Bienvenido al Sistema de Registro e Inicio de Sesión
echo =====MENU PRINCIPAL=====
echo.
echo 1. Registro
echo 2. Inicio de sesion
echo 3. Salir
echo.
echo ========================

set /p opcion="Seleccione una opcion: "

if "%opcion%"=="1" goto registro
if "%opcion%"=="2" goto inicio_sesion
if "%opcion%"=="3" exit

:registro
cls
echo Registro de Usuario
echo.

set /p nuevo_usuario="Ingrese su nuevo nombre de usuario: "
set /p nueva_contrasena="Ingrese su nueva contraseña: "
set /p confirmacion_contrasena="Confirme su nueva contraseña: "

if "%nueva_contrasena%" neq "%confirmacion_contrasena%" (
    echo Las contraseñas no coinciden. Inténtelo de nuevo.
    pause
    goto menu_principal
)

echo %nuevo_usuario%;%nueva_contrasena%>> usuarios.txt

echo.
echo ¡Registro realizado exito!
pause
goto menu_principal

:inicio_sesion
cls
echo Inicio de Sesión
echo.

set /p nombre=Ingrese su nombre de usuario:
set /p contrasena=Ingrese su contraseña:

set "inisesion="
set "encontrado=false"

for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        if "%%b"=="%contrasena%" (
            set "inisesion=true"
            set "encontrado=true"
            goto menu_sesion
        ) else (
            echo Contraseña Incorrecta.
            pause
            goto menu_principal
        )
    )
)

if "%encontrado%"=="false" (
    echo Usuario no encontrado.
    pause
    goto menu_principal
)

if not defined inisesion (
    echo Nombre de usuario no encontrado.
    pause
    goto menu_principal
)

:menu_sesion
cls
echo Opciones Disponibles:
echo.
echo 1. Modificar contraseña
echo 2. Eliminar usuario
echo 3. Cerrar sesión
echo.

set /p opcion_sesion="Seleccione una opción: "

if "%opcion_sesion%"=="1" goto modificar_contrasena
if "%opcion_sesion%"=="2" goto eliminar_usuario
if "%opcion_sesion%"=="3" goto menu_principal

:modificar_contrasena
cls
set /p contrasena=Nueva contraseña:

(for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        echo %%a;!contrasena!
    ) else (
        echo %%a;%%b
    )
)) > Nuevos_Usuarios.txt
echo Contraseña modificada exitosamente.
pause
del usuarios.txt
move Nuevos_Usuarios.txt usuarios.txt
goto menu_sesion


:eliminar_usuario
REM Eliminar el usuario del archivo
cls
Set /p respuesta=¿Esta seguro de que desea borrar el usuario? (S/N):
if "%respuesta%"=="S" (
findstr /v %nombre%;%contrasena% usuarios.txt > usuarios_temp.txt
move /y usuarios_temp.txt usuarios.txt > nul
echo El usuario "%nombre%" ha sido eliminado correctamente.
pause
goto menu_principal
) else if "%respuesta%"=="N" (
echo Perfecto, no borramos el usuario. Le devolvemos a las opciones de su usuario.
pause
goto menu_sesion
) else (
echo No se ha detectado el caracter. "Recuerde escribir la confirmacion en mayusculas"
pause
goto eliminar_usuario
)
)

:ModificarContraseña
cls
set /p contrasena3=Nueva contraseña:

(for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        echo %%a;!contrasena3!
    ) else (
        echo %%a;%%b
    )
)) > Nuevo_Usuario.txt
echo Contraseña modificada exitosamente.
pause
del usuarios.txt
rename Nuevo_Usuario.txt usuarios.txt
goto :MENU_INICIO

:EliminarUsuario
cls
findstr /v /c:%nombre%;%contrasena% usuarios.txt > usuarios.tmp
move /y usuarios.tmp usuarios.txt
echo Usuario eliminado exitosamente. 
timeout 1
goto MENU:
pause
:salir 
:InicioSesion
cls
set /p nombre=Ingrese su nombre de usuario:
set /p contrasena=Ingrese su contraseña:
set "inisesion="
for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        if "%%b"=="%contrasena%" (
            set "inisesion=true"
            goto :MENU_INICIO
        ) else (
            echo Contraseña incorrecta.
            set "inisesion=false"
pause
del usuarios.txt
rename Nuevo_Usuario.txt usuarios.txt
pause
            goto MENU:
        )
    )
)
if not defined inisesion (
    echo Nombre de usuario no encontrado.
pause
    goto MENU:
)

:MENU_INICIO
cls
echo 1. Modificar contraseña
echo 2. Eliminar usuario
echo 3. Cerrar sesión

set /p seleccion=Seleccione una opción:
if "%seleccion%"=="1" (
    call :ModificarContraseña
) else if "%seleccion%"=="2" (
    call :EliminarUsuario
) else if "%seleccion%"=="3" (
    goto MENU:
) else (
    echo Opción no válida. Inténtalo de nuevo.
pause
    goto MENU_INICIO:
)

:ModificarContraseña
cls
set /p contrasena3=Nueva contraseña:

(for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a"=="%nombre%" (
        echo %%a;!contrasena3!
    ) else (
        echo %%a;%%b
    )
)) > Nuevos_Usuarios.txt
echo Contraseña modificada exitosamente.
Del Usuarios.txt
Rename Nuevos_Usuarios.txt Usuarios.txt
pause
goto MENU_INICIO:

:EliminarUsuario
cls
set /p confirm=¿Está seguro de que desea eliminar su usuario? (S/N):

(for /f "tokens=1,* delims=;" %%a in (usuarios.txt) do (
    if "%%a" neq "%nombre%" (
        echo %%a;%%b
    )
)) > usuarios_nuevo.txt

move Nuevos _Usuarios usuarios.txt >nul
echo Usuario eliminado exitosamente.
goto MENU:
pause
:salir 