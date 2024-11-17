use strict;
use warnings;
use utf8;
use open ':std', ':encoding(UTF-8)';

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

my $seccion = "nombre";
my $flag = 0;

my $busqueda = "";
$busqueda = uc($busqueda);

my $departamento = "";
my $provincia = "";
my $distrito = "jaén";

$departamento = uc($departamento);
$provincia = uc($provincia);
$distrito = uc($distrito);

#Abre archivo
open(IN, "<:encoding(UTF-8)","./base-datos/Data_Universidades.csv") or die "No se puede abrir el archivo de texto\n";

#Salto del header para no leer esa parte
<IN>; 
#while que va por todas las lineas
while(my $line = <IN>) {
    my %dict = sacar_datos($line);
    my $valor = $dict{$seccion} || "";
    if ($valor =~ /.*$busqueda.*/ || $valor eq "") {
        if ($dict{departamento} =~ /$departamento/ &&
            ($provincia eq "" || $dict{provincia} =~ /$provincia/) &&
            ($distrito eq "" || $dict{distrito} =~ /$distrito/) ) {

            print "$line\n";
            $flag = 1;
        }
    }
}

close(IN);
if ($flag == 0) {
    print "No se encontro ninguna coincidencia\n";
}
