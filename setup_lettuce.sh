romdir=$PWD
case "$1" in
	-j)
		echo "---------------------------------------------"
		update-alternatives --config java
		update-alternatives --config javac
		echo "---------------------------------------------"
		java -version
		echo "---------------------------------------------"
		exit 0
		;;
	-c)
		echo "---------------------------------------------"
		read -p "BRANCH (L/M/N) = " b
		case "$b" in
			l|L)
				b=cm-12.1
			;;
			m|M)
				b=cm-13.0
			;;
			n|N)
				b=cm-14.1
			;;
			*)
				echo "Invalid branch...!"
				exit 1
			;;
		esac
		read -p "SOURCE (L/C)   = " s
		case "$s" in
			l|L)
				s="LineageOS"
			;;
			c|C)
				s="CyanogenMod"
			;;
			*)
				echo "Invalid source...!"
				exit 1
			;;
		esac
		echo "---------------------------------------------"
		echo -e "\tCOPYING caf trees"
		echo "---------------------------------------------"
		mkdir -p hardware/qcom/audio-caf/msm8916
		cp -r $HOME/workspace/lettuce-trees/$s/$b/hardware/qcom/audio-caf/msm8916 hardware/qcom/audio-caf/msm8916 2>/dev/null
		if ! [ $? -lt 1 ];then echo -e "audio-caf\t\t[FAILED]"; else echo -e "audio-caf\t\t[DONE]"; fi
		mkdir -p hardware/qcom/display-caf/msm8916
		cp -r $HOME/workspace/lettuce-trees/$s/$b/hardware/qcom/display-caf/msm8916 hardware/qcom/display-caf/msm8916 2>/dev/null
		if ! [ $? -lt 1 ];then echo -e "display-caf\t\t[FAILED]"; else echo -e "display-caf\t\t[DONE]"; fi
		mkdir -p hardware/qcom/media-caf/msm8916
		cp -r $HOME/workspace/lettuce-trees/$s/$b/hardware/qcom/media-caf/msm8916 hardware/qcom/media-caf/msm8916 2>/dev/null
		if ! [ $? -lt 1 ];then echo -e "media-caf\t\t[FAILED]"; else echo -e "media-caf\t\t[DONE]"; fi
		if [ "$b" = "cm-12.1" -o "$b" = "cm-13.0" ]; then
			rm -r hardware/qcom/ril-caf 2>/dev/null
			cp -r $HOME/workspace/lettuce-trees/$s/$b/hardware/ril-caf hardware/ril-caf 2>/dev/null
			if ! [ $? -lt 1 ];then echo -e "ril-caf\t\t\t[FAILED]"; else echo -e "ril-caf\t\t\t[DONE]"; fi
		fi
		echo "---------------------------------------------"
		exit 1
		;;
	-st)
		echo "---------------------------------------------"
		read -p "BRANCH (L/M/N) = " b
		case "$b" in
			l|L)
				b=cm-12.1
				br=cm-12.1-caf-8916
			;;
			m|M)
				b=cm-13.0
				br=cm-13.0-caf-8916
			;;
			n|N)
				b=cm-14.1
				br=cm-14.1-caf-8916
			;;
			*)
				echo "Invalid branch...!"
				exit 1
			;;
		esac
		mkdir -p $HOME/workspace
		mkdir -p $HOME/workspace/lettuce-trees
		mkdir -p $HOME/workspace/lettuce-trees/CyanogenMod
		mkdir -p $HOME/workspace/lettuce-trees/CyanogenMod/cm-12.1
		mkdir -p $HOME/workspace/lettuce-trees/CyanogenMod/cm-13.0
		mkdir -p $HOME/workspace/lettuce-trees/CyanogenMod/cm-14.1
		mkdir -p $HOME/workspace/lettuce-trees/LineageOS
		mkdir -p $HOME/workspace/lettuce-trees/LineageOS/cm-12.1
		mkdir -p $HOME/workspace/lettuce-trees/LineageOS/cm-13.0
		mkdir -p $HOME/workspace/lettuce-trees/LineageOS/cm-14.1
		read -p "SOURCE (L/C)   = " s
		case "$s" in
			l|L)
				s="https://github.com/LineageOS"
				src="$HOME/workspace/lettuce-trees/LineageOS"
			;;
			c|C)
				s="https://github.com/CyanogenMod"
				src="$HOME/workspace/lettuce-trees/CyanogenMod"
			;;
			*)
				echo "Invalid source...!"
				exit 1
			;;
		esac
		echo "---------------------------------------------"
		echo -e "\tSeting up trees"
		echo "---------------------------------------------"
		echo "Press enter to begin ..."
		read enterkey
		echo "---------------------------------------------"
		echo "Cloning device tree..."
		echo "---------------------------------------------"
		git clone -b $b --single-branch $s/android_device_yu_lettuce.git $src/$b/device/yu/lettuce
		echo "---------------------------------------------"
		echo "Cloning Shared tree..."
		echo "---------------------------------------------"
		git clone -b $b --single-branch $s/android_device_cyanogen_msm8916-common.git $src/$b/device/cyanogen/msm8916-common
		echo "---------------------------------------------"
		echo "Cloning qcom_common tree..."
		echo "---------------------------------------------"
		git clone -b $b --single-branch $s/android_device_qcom_common.git $src/$b/device/qcom/common
		if ! [ "$b" = "cm-13.0" -o "$b" = "cm-12.1" ];then
			echo "---------------------------------------------"
			echo "Cloning qcom_binaries..."
			echo "---------------------------------------------"
			git clone -b $b --single-branch https://github.com/TheMuppets/proprietary_vendor_qcom_binaries.git $src/$b/vendor/qcom/binaries
		fi
		echo "---------------------------------------------"
		echo "Cloning vendor_yu tree..."
		echo "---------------------------------------------"
		git clone -b $b --single-branch https://github.com/TheMuppets/proprietary_vendor_yu.git $src/$b/vendor/yu
		echo "---------------------------------------------"
		echo "Cloning kernel tree..."
		echo "---------------------------------------------"
		git clone -b $b --single-branch $s/android_kernel_cyanogen_msm8916.git $src/$b/kernel/cyanogen/msm8916
		echo "---------------------------------------------"
		echo "Cloning audio-caf tree..."
		git clone -b $br --single-branch $s/android_hardware_qcom_audio.git $src/$b/hardware/qcom/audio-caf/msm8916
		echo "---------------------------------------------"
		echo "Cloning display-caf tree..."
		git clone -b $br --single-branch $s/android_hardware_qcom_display.git $src/$b/hardware/qcom/display-caf/msm8916
		echo "---------------------------------------------"
		echo "Cloning media-caf tree..."
		git clone -b $br --single-branch $s/android_hardware_qcom_media.git $src/$b/hardware/qcom/media-caf/msm8916
		echo "---------------------------------------------"
		if [ "$b" = "cm-13.0" ];then
			echo "Cloning ril-caf tree..."
			echo "---------------------------------------------"
			git clone -b cm-13.0-caf --single-branch $s/android_hardware_ril-caf.git $src/$b/hardware/ril-caf
			echo "---------------------------------------------"
		fi
		if ! [ -e $HOME/workspace/lettuce-trees/kernel.mk ]; then
			wget -O $HOME/workspace/lettuce-trees/kernel.mk https://github.com/AOSIP/platform_build/raw/n-mr1/core/tasks/kernel.mk &>/dev/null
		fi
		exit 1
		;;
	-tc)
		echo -e "\tToolchains Available for Download"
		echo "---------------------------------------------"
		echo -e "1.\tSabermod v4.9\n2.\tUber v4.9\n3.\tLinaro v4.9"
		echo "---------------------------------------------"
		read -p "Which toolchain do you want (1/2/3)? " tc
		echo "---------------------------------------------"
		case "$tc" in
			1)
				if ! [ -e $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9/sb.dat ]; then
					echo "Cloning SaberMod 4.9 Toolchain..."
					echo "---------------------------------------------"
					git clone -b sabermod --single-branch https://bitbucket.org/xanaxdroid/aarch64-linux-android-4.9.git $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9
					touch $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9/sb.dat
					echo "---------------------------------------------"
				else
					echo "SaberMod 4.9 Toolchain already available..."
					echo "---------------------------------------------"
				fi
				exit 1
				;;
			2)
				if ! [ -e $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9/ub.dat ]; then
					echo "Cloning Uber 4.9 Toolchain..."
					echo "---------------------------------------------"
					git clone https://bitbucket.org/UBERTC/aarch64-linux-android-4.9.git $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9
					touch $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9/ub.dat
					echo "---------------------------------------------"
				else
					echo "Uber 4.9 Toolchain already available..."
					echo "---------------------------------------------"
				fi
				exit 1
				;;
			3)
				if ! [ -e $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9/ln.dat ]; then
					echo "Cloning Linaro 4.9 Toolchain..."
					echo "---------------------------------------------"
					git clone -b linaro --single-branch https://bitbucket.org/xanaxdroid/aarch64-linux-android-4.9.git $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9
					touch $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9/ln.dat
					echo "---------------------------------------------"
				else
					echo "Linaro 4.9 Toolchain already available..."
					echo "---------------------------------------------"
				fi
				exit 1
				;;
			*)
				echo -e "Invaild Choice !"
				exit 1
				;;
		esac
		exit 1
		;;
	-t)
		if ! [ `ls $romdir/prebuilts/gcc/linux-x86/aarch64/*.*|grep def.dat` ]; then
			touch $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/def.dat 2>/dev/null
		fi
		echo "---------------------------------------------"
		echo -e "\tToolchains Selection"
		echo "---------------------------------------------"
		echo -e "1.\tSabermod v4.9\n2.\tUber v4.9\n3.\tLinaro v4.9\n4.\tRestore Toolchain"
		echo "---------------------------------------------"
		read -p "Which toolchain do you want (1/2/3/4)? " ch
		echo "---------------------------------------------"
		case "$ch" in
			1)
				if [ -e $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9/sb.dat ];then
				echo "Copying SaberMod toolchain..."
				echo "---------------------------------------------"
				if ! [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/def.dat ];then
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/sb.dat ];then
						echo -e "Sabermod\t[ACTIVATED]"
						echo "---------------------------------------------"
					else
						if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ub.dat ];then
							mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9 &>/dev/null
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9/sb.dat ];then
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- SaberMod\t\t[FAILED]";else echo -e "- SaberMod\t\t[SUCCESS]";fi
							else
								cp -r $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- SaberMod\t\t[FAILED]";else echo -e "- SaberMod\t\t[SUCCESS]";fi
							fi
						else
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ln.dat ];then
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9 &>/dev/null
								if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9/sb.dat ];then
									mv $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
									if [ $? -gt 0 ];then echo -e "- SaberMod\t\t[FAILED]";else echo -e "- SaberMod\t\t[SUCCESS]";fi
								else
									cp -r $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
									if [ $? -gt 0 ];then echo -e "- SaberMod\t\t[FAILED]";else echo -e "- SaberMod\t\t[SUCCESS]";fi
								fi
							fi
						fi
					fi
				else
					mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/default-aarch64-linux-android-4.9 &>/dev/null
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9/sb.dat ];then
						mv $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
					else
						cp -r $HOME/workspace/toolchains/sabermod-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
						if [ $? -gt 0 ];then echo -e "- SaberMod\t\t[FAILED]";else echo -e "- SaberMod\t\t[SUCCESS]";fi
					fi
				fi
				else
					echo -e "Sabermod TC isn't available on $HOME/workspace/toolchain...\nPlease run ./lettuce.sh -tc and select SaberMod from there to download.\n---------------------------------------------"
				fi
				exit 1
				;;
			2)
			if [ -e $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9/ub.dat ];then
				echo "Copying Uber Toolchain..."
				echo "---------------------------------------------"
				if ! [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/def.dat ];then
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ub.dat ];then
						echo -e "UberTC\t\t[ACTIVATED]"
						echo "---------------------------------------------"
					else
						if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/sb.dat ];then
							mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9 &>/dev/null
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9/ub.dat ];then
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- UberTC\t\t[FAILED]";else echo -e "- UberTC\t\t[SUCCESS]";fi
							else
								cp -r $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- UberTC\t\t[FAILED]";else echo -e "- UberTC\t\t[SUCCESS]";fi
							fi
						else
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ln.dat ];then
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9 &>/dev/null
								if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9/ub.dat ];then
									mv $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
									if [ $? -gt 0 ];then echo -e "- UberTC\t\t[FAILED]";else echo -e "- UberTC\t\t[SUCCESS]";fi
								else
									cp -r $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
									if [ $? -gt 0 ];then echo -e "- UberTC\t\t[FAILED]";else echo -e "- UberTC\t\t[SUCCESS]";fi
								fi
							fi
						fi
					fi
				else
					mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/default-aarch64-linux-android-4.9 &>/dev/null
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9/ub.dat ];then
						mv $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
					else
						cp -r $HOME/workspace/toolchains/ubertc-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
						if [ $? -gt 0 ];then echo -e "- UberTC\t\t[FAILED]";else echo -e "- UberTC\t\t[SUCCESS]";fi
					fi
				fi
			else
				echo -e "UberTC isn't available on $HOME/workspace/toolchain...\nPlease run ./lettuce.sh -tc and select UberTC from there to download.\n---------------------------------------------"
			fi
				exit 1
				;;
			3)
			if [ -e $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9/ln.dat ];then
				echo "Copying Linaro Toolchain..."
				echo "---------------------------------------------"
				if ! [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/def.dat ];then
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ub.dat ];then
						mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9 &>/dev/null
						if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9/ln.dat ];then
							mv $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
							if [ $? -gt 0 ];then echo -e "- Linaro\t\t[FAILED]";else echo -e "- Linaro\t\t[SUCCESS]";fi
						else
							cp -r $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
							if [ $? -gt 0 ];then echo -e "- Linaro\t\t[FAILED]";else echo -e "- Linaro\t\t[SUCCESS]";fi
						fi
					else
						if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/sb.dat ];then
							mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9 &>/dev/null
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9/ln.dat ];then
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- Linaro\t\t[FAILED]";else echo -e "- Linaro\t\t[SUCCESS]";fi
							else
								cp -r $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- Linaro\t\t[FAILED]";else echo -e "- Linaro\t\t[SUCCESS]";fi
							fi
						else
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ln.dat ];then
								echo -e "Linaro\t\t[ACTIVATED]"
								echo "---------------------------------------------"
							fi
						fi
					fi
				else
					mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/default-aarch64-linux-android-4.9 &>/dev/null
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9/ln.dat ];then
						mv $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
					else
						cp -r $HOME/workspace/toolchains/linaro-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
						if [ $? -gt 0 ];then echo -e "- Linaro\t\t[FAILED]";else echo -e "- Linaro\t\t[SUCCESS]";fi
					fi
				fi
			else
				echo -e "Linaro TC isn't available on $HOME/workspace/toolchain...\nPlease run ./lettuce.sh -tc and select Linaro from there to download.\n---------------------------------------------"
			fi
				exit 1
				;;
			4)
				echo "Restoring Toolchain..."
				echo "---------------------------------------------"
				if ! [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/def.dat ];then
					if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ub.dat ];then
						mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/ubertc-aarch64-linux-android-4.9 &>/dev/null
						mv $romdir/prebuilts/gcc/linux-x86/aarch64/default-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
						if [ $? -gt 0 ];then echo -e "- Default\t\t[FAILED]";else echo -e "- Default\t\t[RESTORED]";fi
					else
						if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/sb.dat ];then
							mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/sabermod-aarch64-linux-android-4.9 &>/dev/null
							mv $romdir/prebuilts/gcc/linux-x86/aarch64/default-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
							if [ $? -gt 0 ];then echo -e "- Default\t\t[FAILED]";else echo -e "- Default\t\t[FAILED][RESTORED]";fi
						else
							if [ -e $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/ln.dat ];then
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/linaro-aarch64-linux-android-4.9 &>/dev/null
								mv $romdir/prebuilts/gcc/linux-x86/aarch64/default-aarch64-linux-android-4.9 $romdir/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 &>/dev/null
								if [ $? -gt 0 ];then echo -e "- Default\t\t[FAILED]";else echo -e "- Default\t\t[RESTORED]";fi
							fi
						fi
					fi
				else
					echo -e "- Default Toolchain\t\t[ACTIVATED]"
				fi
				exit 1
				;;
			*)
				echo -e "Invaild Choice !"
				exit 1
				;;
		esac
		exit 1
		;;
-ct)
echo "---------------------------------------------"
read -p "BRANCH (L/M/N) = " b
case "$b" in
	l|L)
		b=cm-12.1
		;;
	m|M)
		b=cm-13.0
		;;
	n|N)
		b=cm-14.1
		;;
	*)
		echo "Invalid branch...!"
		exit 1
		;;
esac
read -p "SOURCE (L/C)   = " s
case "$s" in
	l|L)
		s="LineageOS"
		;;
	c|C)
		s="CyanogenMod"
		;;
	*)
		echo "Invalid source...!"
		exit 1
		;;
esac
echo "---------------------------------------------"
echo -e "Press enter to begin Copying trees from $s/$b"
read enterkey
echo "---------------------------------------------"
echo "Copying device tree..."
mkdir -p $romdir/device/
mkdir -p $romdir/device/yu/
mkdir -p $romdir/device/yu/lettuce
cp -r $HOME/workspace/lettuce-trees/$s/$b/device/yu/lettuce/* $romdir/device/yu/lettuce
if ! [ -e $romdir/device/yu/lettuce/device.mk ];then dt=1; else dt=0; fi

echo "---------------------------------------------"
echo "Copying device/qcom/sepolicy tree..."
if ! [ -e $romdir/device/qcom/sepolicy/Android.mk ];then
	mkdir -p $romdir/device/qcom/
	mkdir -p $romdir/device/qcom/sepolicy
	cp -r $HOME/workspace/lettuce-trees/$s/$b/device/qcom/sepolicy/* $romdir/device/qcom/sepolicy
	if ! [ -e $romdir/device/qcom/sepolicy/Android.mk ];then sp=1; else sp=0; fi
else
	echo " * device/qcom/sepolicy already available..."
	sp=0
fi
echo "---------------------------------------------"
echo "Copying Shared tree..."
mkdir -p $romdir/device/cyanogen
mkdir -p $romdir/device/cyanogen/msm8916-common
cp -r $HOME/workspace/lettuce-trees/$s/$b/device/cyanogen/msm8916-common/* $romdir/device/cyanogen/msm8916-common
if ! [ -e $romdir/device/cyanogen/msm8916-common/Android.mk ];then st=1; else st=0; fi
echo "---------------------------------------------"
echo "Copying qcom_common tree..."
if ! [ -e $romdir/device/qcom/common/Android.mk ];then
	mkdir -p $romdir/device/qcom
	mkdir -p $romdir/device/qcom/common
	cp -r $HOME/workspace/lettuce-trees/$s/$b/device/qcom/common/* $romdir/device/qcom/common
else
	echo "* device/qcom/common/ already available..."
fi
if ! [ -e $romdir/device/qcom/common/Android.mk ];then qc=1; else qc=0; fi
sleep 1
if [ "$b" = "cm-14.0" ] || [ "$b" = "cm-14.1" ];then
	echo "---------------------------------------------"
	echo "Copying qcom_binaries..."
	
	if ! [ -e $romdir/vendor/qcom/binaries/Android.mk ]; then
		mkdir -p $romdir/vendor/qcom
		mkdir -p $romdir/vendor/qcom/binaries
		cp -r $HOME/workspace/lettuce-trees/$s/$b/vendor/qcom/binaries/* $romdir/vendor/qcom/binaries
	else
		echo "* vendor/qcom/binaries/ already available..."
		echo "---------------------------------------------"
	fi
	if ! [ -e $romdir/vendor/qcom/binaries/Android.mk ]; then qb=1; else qb=0; fi
	
fi
if [ "$b" = "cm-12.1" ] || [ "$b" = "cm-13.0" ];then
echo "---------------------------------------------"
echo "* vendor/qcom/binaries/ not required..."
qb=0
fi
echo "---------------------------------------------"
echo "Copying vendor/yu tree..."
mkdir -p $romdir/vendor/yu
cp -r $HOME/workspace/lettuce-trees/$s/$b/vendor/yu/* $romdir/vendor/yu
if ! [ -e $romdir/vendor/yu/lettuce/Android.mk ];then vt=1; else vt=0; fi
echo "---------------------------------------------"
echo "Copying kernel tree..."
mkdir -p $romdir/kernel
mkdir -p $romdir/kernel/cyanogen
mkdir -p $romdir/kernel/cyanogen/msm8916
cp -r $HOME/workspace/lettuce-trees/$s/$b/kernel/cyanogen/msm8916/* $romdir/kernel/cyanogen/msm8916
if ! [ -e $romdir/kernel/cyanogen/msm8916/AndroidKernel.mk ]; then kt=1; else kt=0; fi
echo "---------------------------------------------"
ls $romdir/vendor
echo "---------------------------------------------"
read -p "Enter name of rom's vendor : " vn
echo "---------------------------------------------"
find $romdir/vendor/$vn -name "*common*.mk" && find $romdir/vendor/$vn -name "*main*.mk"
echo "---------------------------------------------"
read -p "Enter path/to/vendor/config/file : " vf
echo "---------------------------------------------"
echo -e "- Creating $(echo $vn)_lettuce.mk"
echo -e "- Creating AndroidProducts.mk"
if ! [ -e $romdir/device/yu/lettuce/cm.mk ];then
	mv $romdir/device/yu/lettuce/lineage.mk $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
	echo "PRODUCT_MAKEFILES := device/yu/lettuce/$(echo $vn)_lettuce.mk" > device/yu/lettuce/AndroidProducts.mk
	echo "s/PRODUCT_NAME := lineage_lettuce/PRODUCT_NAME := $(echo $vn)_lettuce/">$romdir/tmp
	sed -f $romdir/tmp -i $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
	rm $romdir/tmp
else
	mv $romdir/device/yu/lettuce/cm.mk $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
	echo "PRODUCT_MAKEFILES := device/yu/lettuce/$(echo $vn)_lettuce.mk" > device/yu/lettuce/AndroidProducts.mk
	echo "s/PRODUCT_NAME := cm_lettuce/PRODUCT_NAME := $(echo $vn)_lettuce/">$romdir/tmp
	sed -f $romdir/tmp -i $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
	rm $romdir/tmp
fi
echo "s/vendor\/cm\/config\/common_full_phone.mk/">$romdir/tmp1
echo "$(echo $vf)">$romdir/tmp2
sed -i 's/\//\\\//g' $romdir/tmp2
paste --delimiters "" $romdir/tmp1 $romdir/tmp2>$romdir/tmp
sed -i 's/mk$/mk\//' $romdir/tmp
sed -f $romdir/tmp -i $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
rm -r $romdir/tmp*
if [ -e $romdir/build/core/tasks/kernel.mk ];then
	mv $romdir/build/core/tasks/kernel.mk $romdir/kernel.mk.bak
	if [ -e $HOME/workspace/lettuce-trees/kernel.mk ];then
		cp $HOME/workspace/lettuce-trees/kernel.mk $romdir/build/core/tasks/kernel.mk 2>/dev/null
		if [ $? -lt 1 ];then echo -e "\tkernel.mk file replaced.";else echo -e "\tkernel.mk file wasn't replaced.";fi
	else
		wget -O build/core/tasks/kernel.mk https://github.com/AOSIP/platform_build/raw/n-mr1/core/tasks/kernel.mk &>/dev/null
		if [ $? -lt 1 ];then echo -e "\tkernel.mk file replaced.";else echo -e "\tkernel.mk file wasn't replaced.";fi
	fi
fi
echo "---------------------------------------------"
echo -e "- Fixing derps..."
sed -i '/PRODUCT_BRAND/D' $romdir/device/yu/lettuce/full_lettuce.mk
sed -i '/PRODUCT_DEVICE/a PRODUCT_BRAND := YU' $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
sed -i '/common_full_phone.mk/c\$(call inherit-product, vendor/aosp/common.mk' $romdir/device/yu/lettuce/$(echo $vn)_lettuce.mk
sed -i '/config_deviceHardwareKeys/D' $romdir/device/yu/lettuce/overlay/frameworks/base/core/res/res/values/config.xml
sed -i '/config_deviceHardwareWakeKeys/D' $romdir/device/yu/lettuce/overlay/frameworks/base/core/res/res/values/config.xml
echo "---------------------------------------------"
echo -e "- Creating vendorsetup.sh"
if [ -e $romdir/device/yu/lettuce/vendorsetup.sh ]; then
rm $romdir/device/yu/lettuce/vendorsetup.sh 2>/dev/null
cat <<EOF>$romdir/device/yu/lettuce/vendorsetup.sh
add_lunch_combo $(echo $vn)_lettuce-userdebug
EOF
fi
echo "---------------------------------------------"
echo -e "- Creating $(echo $vn)-build.sh"
if ! [ -e $romdir/$(echo $vn)-build.sh ]; then
cat <<EOF>$romdir/$(echo $vn)-build.sh
case "\$1" in
	-c)
		rm -rf $HOME/.ccache &>/dev/null
		make clean && make clobber
		. build/envsetup.sh
		lunch $(echo $vn)_lettuce-userdebug
		make otapackage -j$(cat /proc/cpuinfo|grep processor|wc --lines)
		;;
	*)
		. build/envsetup.sh
		lunch $(echo $vn)_lettuce-userdebug
		make otapackage -j$(cat /proc/cpuinfo|grep processor|wc --lines)
		;;
esac
EOF
chmod a+x $romdir/$(echo $vn)-build.sh
fi
echo "---------------------------------------------"
echo -e "- Creating remove_trees.sh"
if [ -e $romdir/remove_trees.sh ]; then rm -f $romdir/remove_trees.sh &>/dev/null;fi
cat <<EOF>$romdir/remove_trees.sh
echo "---------------------------------------------"
rm -rf $HOME/.ccache &>/dev/null
echo "- Removing device tree..."
rm -rf $romdir/device/yu/lettuce &>/dev/null
echo "---------------------------------------------"
echo "- Removing msm8916-common tree..."
rm -rf $romdir/device/cyanogen/msm8916-common &>/dev/null
echo "---------------------------------------------"
echo "- Removing qcom/common tree..."
rm -rf $romdir/device/qcom/common &>/dev/null
echo "---------------------------------------------"
echo "- Removing qcom/binaries..."
rm -rf $romdir/vendor/qcom/binaries &>/dev/null
echo "---------------------------------------------"
echo "- Removing vendor/yu tree..."
rm -rf $romdir/vendor/yu &>/dev/null
echo "---------------------------------------------"
echo "- Removing kernel tree..."
rm -rf $romdir/kernel/ &>/dev/null
echo "---------------------------------------------"
echo "- Removing caf HAL trees..."
rm -rf $romdir/hardware/qcom/audio-caf/msm8916 &>/dev/null
rm -rf $romdir/hardware/qcom/display-caf/msm8916 &>/dev/null
rm -rf $romdir/hardware/qcom/media-caf/msm8916 &>/dev/null
echo "---------------------------------------------"
EOF
chmod a+x $romdir/remove_trees.sh
echo "---------------------------------------------"
echo -e "\tLOG"
echo "---------------------------------------------"
if [ "$dt" = "1" ]; then echo -e "- device tree\t\t[FAILED]";else echo -e "- device tree\t\t[SUCCESS]";fi
if [ "$st" = "1" ]; then echo -e "- shared tree\t\t[FAILED]";else echo -e "- shared tree\t\t[SUCCESS]";fi
if [ "$qc" = "1" ]; then echo -e "- qcom-common tree\t[FAILED]";else echo -e "- qcom-common tree\t[SUCCESS]";fi
if [ "$vt" = "1" ]; then echo -e "- vendor_yu\t\t[FAILED]";else echo -e "- vendor_yu\t\t[SUCCESS]";fi
if [ "$vc" = "1" ]; then echo -e "- vendor_cm\t\t[FAILED]";else echo -e "- vendor_cm\t\t[SUCCESS]";fi
if [ "$qb" = "1" ]; then echo -e "- qcom binaries\t\t[FAILED]";else echo -e "- qcom binaries\t\t[SUCCESS]";fi
if [ "$kt" = "1" ]; then echo -e "- kernel tree\t\t[FAILED]";else echo -e "- kernel tree\t\t[SUCCESS]";fi
if [ "$sp" = "1" ]; then echo -e "- qcom/sepolicy\t\t[FAILED]";else echo -e "- qcom/sepolicy\t\t[SUCCESS]";fi
echo "---------------------------------------------"
exit 1
;;
*)
	echo -e "\t---------------------------------------------"
	echo -e "\t|               HELP MENU                   |"
	echo -e "\t---------------------------------------------"
	echo -e "\t|   -j     Switch jdk versions              |"
	echo -e "\t|   -c     Copy some caf HAL trees          |"
	echo -e "\t|   -t     Switch toolchain for compilation |"
	echo -e "\t|   -st    Download device trees for later  |"
	echo -e "\t|          use                              |"
	echo -e "\t|   -ct    Copy device trees to working-dir |"
	echo -e "\t|   -tc    Download toolchain for later use |"
	echo -e "\t---------------------------------------------"
exit 1
;;
esac