#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use Text::CSV;

my $q = CGI->new;
print $q->header(-type => "text/html", -charset => "UTF-8");

# Leer parámetros del formulario
my $seccion = $q->param("seccion") || "";
my $busqueda = $q->param("busqueda") || "";
my $departamento = $q->param("departamento") || "";
my $provincia = $q->param("provincia") || "";
my $distrito = $q->param("distrito") || "";

# Ruta al archivo CSV
my $csv_file = "../cgi-bin/Universidades_Lab06.csv";

# Validar si el archivo CSV existe
if (!-e $csv_file) {
    print "<h1>Error: Archivo de datos no encontrado.</h1>";
    exit;
}

# Leer el archivo CSV
open my $fh, "<", $csv_file or die "No se puede abrir el archivo $csv_file: $!";
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1, sep_char => ',' });

# Extraer encabezados
my $header = $csv->getline($fh);
my @columns = @$header;

# Filtrar datos
my @resultados;
while (my $row = $csv->getline($fh)) {
    my %data;
    @data{@columns} = @$row;

    # Aplicar filtros
    next if $seccion && $busqueda && $data{$seccion} !~ /\Q$busqueda\E/i;
    next if $departamento && $data{"DEPARTAMENTO"} !~ /\Q$departamento\E/i;
    next if $provincia && $data{"PROVINCIA"} !~ /\Q$provincia\E/i;
    next if $distrito && $data{"DISTRITO"} !~ /\Q$distrito\E/i;

    push @resultados, \%data;
}
close $fh;


