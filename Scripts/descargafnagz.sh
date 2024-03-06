#!/bin/bash

# Guarda las salidas
fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")
exec > ../REPORTES/reporte$fecha_hora.txt 2>&1


# Archivos
accessions="../DATOS/ACCESIONES/Accessions.txt"
busca="../DATOS/BASEDATOS_NAFTP/proka_nombre_accesion_ftp.txt"
guarda="../RESULTADOS/BUSQUEDAS/resultados_accesiones_buscadas.txt"

# Buscar y almacenar los resultados en el archivo
grep -F -f "$accessions" "$busca" > "$guarda"

# Mostrar archivo
head -n 5 "$guarda"
# Guarda la longitud de la cantidad de registros y ademas concatena todos losdatos de las FTP para manipularlas
longitud=$(wc -l < $guarda)
ftp=$(cut -f 3 $guarda)

# Elimina  el titulo de la columna extraida
puro=$(echo "$ftp" | awk 'NR>=2 && NR<=$longitud {print $1}')

# Manipula cada uno de los datos para hacerlos visibles a la descarga
echo "$puro" | sed -E "s/GCA/GCF/g" | sed -E "s/ftp:/http:/g" | sed -E "s/(GCF_(.*))/\1\/\1_genomic.fna.gz/g" > ../RESULTADOS/BUSQUEDAS/http_GCF.txt

# Guarda la direccion de donde estan las actuales HTTP que eran FTP. Asi como los muestra para ver que se cumplio el comando.
filtr="../RESULTADOS/BUSQUEDAS/http_GCF.txt"
http=$(cut -f 1 $filtr)
head -n 5 $filtr

# Entra a esta carpeta para depositar aqui las secuencias
cd ../RESULTADOS/GENOMAS

# Empezamos la descarga de cada unas de las accesiones.
n=1
for i in $http
do
	echo "$i"
	wget $i
done

# Muestra los datos extraidos.
ls ./

# Busca si se encuentra la accesion descargada.
for i in accessions
do
	

done
