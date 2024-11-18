#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';
use CGI;

#Función que de una linea de los datos csv sacara cada parte y la pondra en un hashmap que luego retornara
sub sacar_datos {
    my $line = $_[0];
    my %dict;

    if ($line =~ /^(\d+)
                    ,([^\t]+)
                    ,([^\t]+)
                    ,([^\t]+)
                    ,(\d+)?
                    ,(\d+)?
                    ,(\d+)
                    ,([^\t]+)
                    ,([^\t]+)
                    ,([^\t]+)
                    ,(\d+)
                    ,([-]?\d*\.?\d+)
                    ,([-]?\d*\.?\d+)
                    ,(\d+)/x) {
        $dict{codigo_entidad} = $1;
        $dict{nombre} = $2;
        $dict{seccion_gestion} = $3;
        $dict{estado_licenciamiento} = $4;
        $dict{fecha_inicio_licenciamiento} = $5;
        $dict{fecha_fin_licenciamiento} = $6;
        $dict{periodo_licenciamiento} = $7;
        $dict{departamento} = $8;
        $dict{provincia} = $9;
        $dict{distrito} = $10;
        $dict{ubigeo} = $11;
        $dict{latitud} = $12;
        $dict{longitud} = $13;
        $dict{fecha_corte} = $14;
    }
    return %dict;
}

my $cgi = CGI -> new();

my $seccion = $cgi->param("section") || "";

my $busqueda = $cgi->param("busqueda") || "";
$busqueda = uc($busqueda);

my $departamento = $cgi->param("departamento") || "";
my $provincia = $cgi->param("provincia") || "";
my $distrito = $cgi->param("distrito") || "";

$departamento = uc($departamento);
$provincia = uc($provincia);
$distrito = uc($distrito);

#Abre archivo
open(IN, "<:encoding(UTF-8)","./Universidades_Lab06.csv") or die "No se puede abrir el archivo de texto\n";
#Salto del header para no leer esa parte
<IN>; 

print "Content-Type: text/html\n\n";

print "<!DOCTYPE html>\n";
print "<html lang='es'>\n";
print "<head>\n";
print "<meta charset='UTF-8'>\n";
print "<title>Busqueda Universidades</title>\n";
print "<link rel='stylesheet' href='../css/style.css'>\n";
print "</head>\n";
print "<body>\n";

print "<header>\n";
print "<h1>Datos de Universidades del Perú</h1>\n";
print "</header>\n";

print "<section class='section-formulario'>\n";
print "<p>Ingrese datos para buscar en la base de datos</p>\n";

print "<form action='../cgi-bin/lab06.pl'>\n";
print "<div class='div-form-opcion'>\n";
print "<select name='seccion' id='seccion'>\n";
print "<option value='' hidden disabled selected>SELECCIONE OPCIÓN</option>\n";
print "<option value='nombre'>NOMBRE</option>\n";
print "<option value='gestion'>TIPO DE GESTIÓN</option>\n";
print "<option value='estado-licenciamiento'>ESTADO DE LICENCIAMIENTO</option>\n";
print "<option value='inicio-licenciamiento'>FECHA INICIO DE LICENCIAMIENTO</option>\n";
print "<option value='fin-licenciamiento'>FECHA FIN DE LICENCIAMIENTO</option>\n";
print "<option value='periodo'>PERIODO DE LICENCIAMIENTO</option>\n";
print "</select>\n";

print "<input type='text' name='busqueda' placeholder='INGRESE BÚSQUEDA' autocomplete='off'>\n";
print "</div>\n";

print "<div class='div-form-lugar'>\n";
print "<select name='departamento' id='departamento'>\n";
print "<option value='' hidden disabled selected>DEPARTAMENTO</option>\n";
print "<option value='AMAZONAS'>AMAZONAS</option>\n";
print "<option value='ANCASH'>ANCASH</option>\n";
print "<option value='APURIMAC'>APURÍMAC</option>\n";
print "<option value='AREQUIPA'>AREQUIPA</option>\n";
print "<option value='AYACUCHO'>AYACUCHO</option>\n";
print "<option value='CAJAMARCA'>CAJAMARCA</option>\n";
print "<option value='CALLAO'>CALLAO</option>\n";
print "<option value='CUSCO'>CUSCO</option>\n";
print "<option value='HUANCAVELICA'>HUANCAVELICA</option>\n";
print "<option value='HUANUCO'>HUÁNUCO</option>\n";
print "<option value='ICA'>ICA</option>\n";
print "<option value='JUNIN'>JUNÍN</option>\n";
print "<option value='LA LIBERTAD'>LA LIBERTAD</option>\n";
print "<option value='LAMBAYEQUE'>LAMBAYEQUE</option>\n";
print "<option value='LIMA'>LIMA</option>\n";
print "<option value='LORETO'>LORETO</option>\n";
print "<option value='MADRE DE DIOS'>MADRE DE DIOS</option>\n";
print "<option value='MOQUEGUA'>MOQUEGUA</option>\n";
print "<option value='PASCO'>PASCO</option>\n";
print "<option value='PIURA'>PIURA</option>\n";
print "<option value='PUNO'>PUNO</option>\n";
print "<option value='SAN MARTIN'>SAN MARTIN</option>\n";
print "<option value='TACNA'>TACNA</option>\n";
print "<option value='TUMBES'>TUMBES</option>\n";
print "<option value='UCAYALI'>UCAYALI</option>\n";
print "</select>\n";

print "<input type='text' name='provincia' id='provincia' placeholder='PROVINCIA' autocomplete='off'>\n";
print "<input type='text' name='distrito' id='distrito' placeholder='DISTRITO' autocomplete='off'>\n";
print "</div>\n";

print "<div class='div-form-submit'>\n";
print "<input type='submit' value='Buscar'>\n";
print "</div>\n";
print "</form>\n";
print "</section>\n";

# Mostrar los resultados de la búsqueda (esto es solo ejemplo)
print "<section class='section-tabla'>\n";

my $contador = 0;
while(my $line = <IN>) {
    my %dict = sacar_datos($line);
    my $valor = $dict{$seccion} || "";
    if ($valor =~ /.*$busqueda.*/ || $valor eq "") {

        #tabla de headers
        if ($contador == 0) {
            print "<div class='divTable'>\n";
            print "<div class='divTableHeading'>\n";
            print "<div class='divTableRow div-text-center'>\n";
            print "<div class='divTableHead tab-codigo'>CODIGO_ENTIDAD</div>\n";
            print "<div class='divTableHead tab-nombre'>NOMBRE</div>\n";
            print "<div class='divTableHead tab-gestion'>TIPO_GESTIÓN</div>\n";
            print "<div class='divTableHead tab-estado'>ESTADO_LICENCIAMIENTO</div>\n";
            print "<div class='divTableHead tab-inicio'>FECHA_INICIO_LICENCIAMIENTO</div>\n";
            print "<div class='divTableHead tab-fin'>FECHA_FIN_LICENCIAMIENTO</div>\n";
            print "<div class='divTableHead tab-periodo'>PERIODO_LICENCIAMIENTO</div>\n";
            print "<div class='divTableHead tab-departamento'>DEPARTAMENTO</div>\n";
            print "<div class='divTableHead tab-provincia'>PROVINCIA</div>\n";
            print "<div class='divTableHead tab-distrito'>DISTRITO</div>\n";
            print "<div class='divTableHead tab-ubigeo'>UBIGEO</div>\n";
            print "<div class='divTableHead tab-latitud'>LATITUD</div>\n";
            print "<div class='divTableHead tab-longitud'>LONGITUD</div>\n";
            print "<div class='divTableHead tab-corte'>FECHA_CORTE</div>\n";
            print "<div class='divTableHead tab-dir'>DIRECCIÓN</div>\n";
            print "</div>\n";
            print "</div>\n";
            print "<div class='divTableBody'>\n";
        }

        if ($dict{departamento} =~ /$departamento/ &&
            ($provincia eq "" || $dict{provincia} =~ /$provincia/) &&
            ($distrito eq "" || $dict{distrito} =~ /$distrito/) ) {

            print "<div class='divTableRow'>\n";
            print "<div class='divTableCell tab-codigo'>$dict{codigo_entidad}</div>\n";
            print "<div class='divTableCell tab-nombre'>$dict{nombre}</div>\n";
            print "<div class='divTableCell tab-gestion'>$dict{seccion_gestion}</div>\n";
            print "<div class='divTableCell tab-estado'>$dict{estado_licenciamiento}</div>\n";
            print "<div class='divTableCell tab-inicio'>$dict{fecha_inicio_licenciamiento}</div>\n";
            print "<div class='divTableCell tab-fin'>$dict{fecha_fin_licenciamiento}</div>\n";
            print "<div class='divTableCell tab-periodo'>$dict{periodo_licenciamiento}</div>\n";
            print "<div class='divTableCell tab-departamento'>$dict{departamento}</div>\n";
            print "<div class='divTableCell tab-provincia'>$dict{provincia}</div>\n";
            print "<div class='divTableCell tab-distrito'>$dict{distrito}</div>\n";
            print "<div class='divTableCell tab-ubigeo'>$dict{ubigeo}</div>\n";
            print "<div class='divTableCell tab-latitud'>$dict{latitud}</div>\n";
            print "<div class='divTableCell tab-longitud'>$dict{longitud}</div>\n";
            print "<div class='divTableCell tab-corte'>$dict{fecha_corte}</div>\n";
            print "<div class='divTableCell tab-dir'><a href='https://google.com/maps/place/$dict{latitud},$dict{longitud}'/a>Ver dirección</div>\n";
            print "</div>\n";

            $contador++;
        }
    }
    
}

close(IN);
if ($contador != 0) {
    print "</div>\n";  # Cierra la divTableBody
    print "</div>\n";  # Cierra la divTable
}


print "<div class='div-resultados-text'>\n";
print "<p>Encontrados: $contador Universidades</p>\n";
print "</div>\n";

print "</section>\n";

print "</body>\n";
print "</html>\n";
