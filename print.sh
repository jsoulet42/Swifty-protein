#!/bin/bash

# Définir le dossier de travail comme le répertoire "lib"
directory="./lib"

# Fichier de sortie
output_file="./print_out.txt"

# Vider le fichier de sortie s'il existe déjà pour éviter une accumulation
> "$output_file"

# Trouver tous les fichiers dans le dossier lib en excluant node_modules, public, et yarn.lock
find "$directory" -type f ! -path "./node_modules/*" ! -path "./public/*" ! -name "yarn.lock" | while read -r file; do
    echo "==== $file ====" >> "$output_file"
    cat "$file" >> "$output_file"
    echo -e "\n" >> "$output_file"
done
