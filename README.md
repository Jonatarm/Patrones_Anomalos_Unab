# Patrones_Anomalos_Unab
Patrones Anómalos Unab

Objetivo.
El presente README busca entregar los pasos necesarios para que el sistema de detección y categorización de posibles amenazas en una red sea implementado sin problemas en una o mas redes. 

Desarrollo.
A continuación se indicaran  los pasos para desplegar el sistema:
Consideración:
El equipo o Hardware donde se despliegue este laboratorio debe contar con al menos 10 Gb disponibles de Memoria RAM, esto con el objetivo de cubrir las capacidades mínimas de operación del sistema y de pruebas.
Estas consideraciones son solo para testear que el sistema opera en forma normal, para implementarlo en producción a gran escala, los requerimientos aumentaran y van a depender de la realidad de cada red. 

1.	En primer lugar debemos descargar los archivos alojados en el siguiente Drive (demora bastante la descarga, considerar que son alrededor de 50 Gb en total):

	https://drive.google.com/open?id=1A38iMwh4PAiq0uZ25KOAOY5woKr-csHv
	 
Figura 1: Maquinas virtuales provistas

2.	Posterior a esto o en paralelo debemos realizar es tener dentro de la red un Servidor con “Vmware Work Station” (Ambiente de pruebas) o “Vmware ESXi” 		(Producción a gran escala), desde este servidor se administraran las maquinas virtuales y el sistema en general.

3.	Luego hacemos doble clic y cargamos las maquinas virtuales de acuerdo a siguiente detalle:
	a)	Mail_Server_Unab
	b)	pfSense_Unab_v.1.2
	c)	Graylog_Unab_v1.2
	d)	Lamp_Unab
	e)	Kali_Unab
	Se debe tener presente que como son maquinas OVF, estas ya vienen con una configuración de red previa, esta puede ser cambiada por el encargado de red, de 	   acuerdo a sus requerimientos.
	Objeto evitar posibles fallas en el despliegue de las maquinas virtuales, lo importante es instalarlas una a una, esperando que todo su proceso de instalación 	       termine de forma correcta.

4.	Adicionalmente a estas maquinas debieran existir “Equipos_Clientes” o dispositivos de conectividad (Firewall, Router, Switch, etc.), dependiendo la realidad 	     de cada red, estos serán los encargados en conjunto con pfsense de alimentar el sistema.

5.	Posterior a esto hay un proceso de configuración de la red, esto va a ir variando dependiendo de la realidad de cada implementación, pero en general, lo que 	     se busca es que:

	a)	Todo el trafico de la red pase y se gestione a través de pfSense. Para esto deberíamos tener una interfaz del PfSense como red WAN (La que da hacia 		    fuera de mi red) y otra interfaz como LAN (Dentro de mi red), adicionalmente se puede agregar una tercera interfaz como ADMIN (Esto es opcional), 			objeto de esto es que todas estas maquinas se puedan visualizar entre ellas e intercambiar datos.
	b)	Debemos tener en cuenta que pfSense tiene un servicio DHCP habilitado para su LAN, a raíz de esto todas las maquinas que estén tomadas de esa interfaz 		       recibirán un direccionamiento IP que será asignado por pfSense. Esto se realiza objeto gestionar de mejor forma todos los equipos que pasen por 			pfSense, esto se puede deshabilitar.

6.	Visualizaciones de las maquinas operando en forma normal:

	a)	pfSense_Unab
	b)	Mail_Server_Unab
	c)	Graylog_Unab
	d)	Lamp_Unab

7.	Credenciales del equipamiento:

	a)	Mail_Server_Unab
	User: root
	Pass: test

	b)	pfSense_Unab
	User: admin
	Pass: Unab.2020

	c)	Lamp_Unab
	User: root
	Pass: Unab.2020

	d)	Graylog_Unab
	User: root
	Pass: Temerac2018

	Web
	User: admin
	Pass: Temeracbeta2020

8.	Posterior a esto, encendemos las 2 maquinas virtuales “Graylog_Unab” y “Mail_Server_Unab”, dejamos de que ambas maquinas finalicen su proceso de encendido.

9.	Luego ingresamos a “Graylog_Unab” a través del usuario “jonathan”, en donde la Password es “Temerac2018”.

10.	 Estando dentro de esta abriremos una ventana terminal. A través del comando “ifconfig” consultamos direccionamiento de red. Tomamos nota de la ip que aparece 		en ens33 “inet addr: 172.16.100.3” (en este caso), ya que esta debemos reemplazarla en el archivo que detallaremos mas adelante.

11.	Posterior a esto nos dirigimos al archivo de configuración de Graylog, con el siguiente comando # sudo nano /etc./Graylog/server/server.conf. Ingresaremos 	   nuevamente la Password “Temerac2018”.

12.	Visualizaremos siguiente archivo, en donde nos debemos dirigir a “http_”, esto lo podemos hacer mas rápido a través de “ctrl + w” y tipeamos 			“http_bind_address”, aquí debemos reemplazar el valor con la ip que habíamos copiado anteriormente (xxx.xxx.xxx.xxx:9000). Posterior a este cambio “ctrl + o” 	      y enter para guardar.

13.	Dentro del mismo archivo y con las teclas “ctrl + w” tipeamos “email transport” y enter, llegando a esta sección del archivo, debemos configurar la misma ip 	     anterior, tal como se ve en la siguiente figura.

14.	En la sección recién vista del archivo (#Email transport), también se efectúa la configuración del servidor de correo (dominio @lab.cl), con el cual se 	establecerá la comunicación, en este caso la configuración ya esta realizada y solo se debe cambiar la ip de la Uri, de acuerdo a lo solicitado en el pto. 11. 	       Posterior a esto presionamos “ctrl + o” y enter para guardar, luego “ctrl + x” para salir.

15.	Posterior a esto reiniciamos el correlacionador, con el comando #sudo systemctl restart graylog-server

16.	Ahora instalaremos y configuraremos Graylog-Sidecar (agente) en un equipo(s) Windows, lo primero que haremos en equipo Windows será ejecutar el archivo 	graylog_sidecar_installer_1.0.2-1, el cual estará junto a las maquinas virtuales, dejamos que el proceso de instalación termine.

17.	Posterior a esto buscamos CMD y lo ejecutamos como “administrador”.

18.	Estando dentro de CMD vamos al archivo de configuración de Graylog-Sidecar, con el siguiente comando notepad.exe C:\Program Files\Graylog\sidecar\sidecar.yml. 	       Aquí seteamos la dirección ip de Graylog_Unab en la línea server_url: http://xxx.xxx.xxx.xxx:9000/api, como aparece en la figura de abajo. Luego “ctrl + g” 	   para guardar y cerramos el archivo.

19.	Creamos un API Token para este input desde System/Autenthication aquí seleccionamos “provider setting” del panel izquierdo y le damos un nombre al nuevo 	Token, posterior a esto lo copiamos y reemplazamos en  este archivo ya editado de configuración de Graylog_Sidecar.

	Nota: Ya hay creado un Api Token “Windows_Token_Sidecar_Unab”, también se puede copiar este y reemplazar en el archivo ya editado.
	server_api_token: "d52sfsoiridmrk8ju25q2s1u2p93flm9qmv1okm2qt802nn1noj" (Token ejemplo).

20.	Luego dentro de CMD ejecutamos siguientes comandos:
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service install
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service start
	En el caso de que el proceso estuviera corriendo, ejecutamos:
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service stop y luego:
	"C:\Program Files\graylog\sidecar\graylog-sidecar.exe" -service start

21.	Luego ingresamos a Graylog http://ipa.ddr.ess.ss:9000/ y nos dirigimos a System/Sidecard/Configuration y en el archivo de configuración en host seteamos la ip 	       de Graylog_Unab, como muestra la figura de abajo (hosts: ["ipa.ddr.ess.sss:5044"]) (en este caso es esa ip). Luego abajo le damos “Update”.	

22.	Posterior a estos nos dirigimos a “Alertas”, menú que se encuentra en el panel superior y vamos a “Notifications”, luego en “Alerta de seguridad” le damos 	   clic a “More actions” y le damos a “edit”.

23.	Debemos dejar siguiente configuración, en E-mails receivers dejaremos la cuenta jonathan@lab.cl que es el receptor y una de las cuentas configuradas en el 	   servidor de correo “Mail_Server_Unab”, le damos “Save” con la cual guardaremos dicha configuración.

24.	Ahora instalaremos en otros equipo (Que seria el equipo donde efectuare el monitoreo y donde recibiré los correos) un gestor de correo, las pruebas e 		implementación se realizaron con Thunderbird, posterior a la instalación configuraremos 2 cuentas de correos en este gestor, de acuerdo a siguiente detalle:
	Cuenta 1.
	Nombre: jonathan@lab.cl
	Cuenta 2.
	Nombre: graylog@lab.cl

	Ambas cuentas deben que configuradas de acuerdo a las figuras (figura 1 – figura 2) de mas abajo.
	Se debe tener presente para ambas cuentas:
	a)	Your name: El que desee.
	b)	Email address: jonathan@lab.cl (cuenta 1) y graylog@lab.cl (cuenta 2).
	c)	Password: test2020
	d)	Server hostname: 172.16.100.2 (Es la dirección ip del servidor de correo “Mail_Server_Unab”).
	e)	Puerto IMAP: 143
	f)	Puerto SMTP: 25

25.	Posterior a esto nos vamos a la maquina “Graylog_Unab” y seteamos como DNS de esta la dirección ip del servidor de correo “Mail_Server_Unab”, también como se 	      muestra en las figuras siguientes se recomienda dejar direccionamiento IP en “Manual” y setera mismos datos ya asignados (#ifconfig).

26.	Objeto ver si configuración esta correcta y las alertas (correos) quedaron bien seteados, nos dirigimos a  “Alert”, dentro de este nos vamos a “Notifications” 	       y buscamos la alerta configurada que lleva por nombre “Alerta de Seguridad”, aquí hacemos clic en el botón “Test”, si esta todo bien nos debiera llegar un 	  correo a la cuenta jonathan@lab.cl.

27.	Mientras usted se encuentra trabajando en otras actividades frente al computador, las notificaciones deben aparecer como pop-up.

28.	Respecto al servidor de correo “Mail_Server_Unab”, las credenciales para ingresar son las siguientes:

	User: root / Pass: test
	User: test / Pass: test

29.	En el caso de que servidor de correo presente problemas, se debe verificar a través del comando #nano etc/bind/db.lab.cl que las ip´s que tiene configuradas 	     son las asignadas (misma ip del servidor de correo).

30.	A continuación se despliega la visualización del sistema de correlación.
	Esta es la visualización que debemos ver para hacer ingreso al correlacionador de eventos Graylog, con las credenciales entregadas.

	Una de las primeras visualizaciones que tendremos es esta en donde podemos ver el Histograma, en donde se pueden apreciar los eventos que están ingresando al 	      sistema.
	En el costado derecho podemos visualizar la cantidad de eventos recolectada y la cantidad de tiempo empleada en esta, lo cual nos hace ver que efectivamente 	     el flujo de datos es considerable.
 

	Si hacemos clic sobre uno de los eventos que se encuentran bajo el Histograma, notaremos que se despliega este evento y se pueden visualizar todos los 		componentes que forman parte de ese determinado log. Esto quita una gran carga de trabajo a los encargados de Seguridad TI, ya que podemos apreciar de forma 	     rápida y certera quien es el origen del evento, su dominio, dependencia, hora de ocurrencia y otros datos que son de vital importancia para en caso lo 		requiera mitigar un incidente informático.
	
31.	A continuación se incluye un paso a paso de como “Operar en Graylog”:

	a)	Ingresamos a la plataforma Graylog, de acuerdo a siguiente detalle:

	URL	:	http://xxx.xxx.xxx.xxx:9000/
	User	:	admin
	Pass	:	Temeracbeta2020

 
	b)	A continuación nos dirigimos al símbolo de “Play”, donde debe tener la opción “Not updating” y le damos clic y seleccionamos la opción que 			necesitemos, esto le da la instrucción al sistema de que actualice sus datos y log en el tiempo configurado.

 	c)	A continuación le damos clic al botón “Show alerts”, aquí visualizaremos todas las alertas que se han gatillado.

	d)	Posterior a estos nos dirigimos al menú “Alerts”, el cual se encuentra en el panel superior,  vamos a “Notifications”, luego en “Alerta de seguridad” 		      le damos clic a “More actions” y le damos a “Edit”. 

	e)	En las figura N° 5 y N° 6 podemos ver el originador y el destinatario de las cuentas de correo a la cual se enviara el correo con la notificación de 		     la alerta de seguridad. Esto con el objeto de que el personal de seguridad TI o el encargado tome las acciones de mitigación.

	f)	Si nuestra intención es solo visualizar la configuración de la notificación y no efectuar cambios en esta dentro de la pestaña “Notifications”, 		hacemos clic en “show configuration”, opción que se encuentra en la parte inferior de Alerta de seguridad.

	g)	En el equipo destinado para monitoreo se configuro un gestor de correo (Thunderbird) la cuenta para la recepción de las notificaciones 				(jonathan@lab.cl, para pruebas), esta cuenta será la encargada de recibir los distintos correos con notificaciones de Alertas de Seguridad.
 
		Cuenta 1.
		Nombre: jonathan@lab.cl

		Cuenta 2.
		Nombre: graylog@lab.cl
		Ambas cuentas deben que configuradas de acuerdo a las figuras (figura 1 – figura 2) de mas abajo.
		Se debe tener presente para ambas cuentas:

		a)	Your name: Jonathan Armijo (Ejemplo).
		b)	Email address: jonathan@lab.cl (cuenta 1) y graylog@lab.cl (cuenta 2).
		c)	Password: test2020
		d)	Server hostname: 172.16.100.2 (Es la dirección ip del servidor de correo “Mail_Server_Unab”).
		e)	Puerto IMAP: 143
		f)	Puerto SMTP: 25
 
	h)	Objeto ver si configuración esta correcta y las alertas (correos) quedaron bien seteados, nos dirigimos a  “Alert”, dentro de este nos vamos a 			“Notifications” y buscamos la alerta configurada que lleva por nombre “Alerta de Seguridad”, aquí hacemos clic en el botón “Test”, si esta todo bien 		     nos debiera llegar un correo a la cuenta jonathan@lab.cl.
 
	i)	Mientras usted se encuentra trabajando en otras actividades frente al computador, las notificaciones deben aparecer como indica la siguiente figura:
 
	j)	Al abrir el gestor de correo, este le solicitara la Password del usuario, esta es test2020, ingresamos esta Password y le damos ok.
 
	k)	Al recibir un correo electrónico con el detalle de una alerta de seguridad, lo que procederemos a realizar es hacer clic en esta alerta desplegando 		    los detalles de esta, si los detalles que se aprecian en este no son convincentes de que efectivamente estamos frente a un incidente informático, 			haremos clic en el link “Stream URL” inserto en el mismo correo, este link nos redirigirá hacia el sistema de correlación de eventos, desde donde fue 		      gatillada y enviada la alerta. Aquí podremos revisar en detalle la alerta enviada por el sistema

	l)	Normalmente el operador de seguridad o la persona encargada de informática, en el caso que tenga la disponibilidad para monitorear la red debiera 		  mantener en visual este Dashboards, el cual muestra bastante detalles de lo que esta circulando por la red.

		 Desde este Dashboards podemos visualizar y realizar siguientes acciones:

		a)	Búsqueda de eventos o logs (Type your search…..)
		b)	Visualización de los distintos mensajes (Messages)
		c)	Peak de eventos (Histogram)
		d)	Búsqueda histórica e en tiempo real (Search in the last….)
		e)	Despliegue en detalle de los distintos eventos (Clic en messages)

32.	Para cargar reglas Snort a pfSense, nos dirigimos al siguiente menú
	
	Seleccionamos WAN Barnyard2 y siguiente configuración:
		Habilitar el logging y envío de eventos a Graylog.  
		Vamos a WAN Settings y realizamos siguiente configuración.
		Luego nos dirigimos al menú de “Global Settings”
		Ahí se nos solicitara un código “oinkmaster”, el cual se debe gestionar a través del link adjunto.
		Luego vamos a WAN rules.
 
		Son bastantes y variadas las reglas Snort que se nos presentan.
		Vamos a Update rule, aquí podemos ver las actualizaciones de las reglas

 33.	Dentro de Graylog hay creado un “Panel” con el nombre “pfSense_Rules”, el cual muestra todos los eventos gatillados de posibles amenazas, las cuales han sido 	      enviadas por pfSense.
