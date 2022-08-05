#!/bin/bash
Score=0

#read name
read -p"Enter Your Name: " name

#array & initalize
declare -A arr
declare -A tempArr

initialize(){
	for((i=0;i<4;i++))
	{
		for((j=0;j<4;j++))
		{
			arr[$i,$j]=0
		}
	}
	#generate the board
	local row=$(( RANDOM % 4 ))
	local col=$(( RANDOM % 4 ))
	arr[$row,$col]=4

	for((;;))
	{
		row=$(( RANDOM % 4))
		col=$(( RANDOM % 4))

		if((arr[$row,$col]==0))
		then
			local temp=RANDOM%10
			temp=$(( temp % 2 ))
			temp=$(( temp + 1 ))
			arr[$row,$col]=$(( 2**temp))
			break
		fi
	}


	echo "===================================="
	echo "|               2048               |"
	echo "===================================="
	echo

	echo "__________PRESS s to Start__________"
	echo

	for((;;))
	{
		read -p"Enter Command: " c
		if [ "$c" = "s" ]
		then
			printf "\033c"
			break
		fi
	}

}


#generate Random Number
randomNumber(){

	for((;;))
	{
		local row=$(( RANDOM % 4))
		local col=$(( RANDOM % 4))

		if((arr[$row,$col]==0))
		then
			local temp=RANDOM%10
			temp=$(( temp % 2 ))
			temp=$(( temp + 1 ))
			arr[$row,$col]=$(( 2**temp))
			break
		fi
	}
}




#moveup
moveup(){

for((j=0;j<4;j++)){

	isaddable=1

	for((i=1;i<4;i++))
	{
		if((arr[$i,$j]!=0))
		then

			for((k=i;k>0;k--))
			{

				if((arr[$((k-1)),$j]==0))
				then
					arr[$((k-1)),$j]=${arr[$k,$j]}
					arr[$k,$j]=0
				elif [ ${arr[$k,$j]} -eq ${arr[$((k-1)),$j]} ] && [ $isaddable -eq 1 ];
				then
					arr[$((k-1)),$j]=$(( arr[$k,$j]*2 ))
					Score=$(( arr[$k,$j] + Score))
					arr[$k,$j]=0
					local isaddable=0
				else
					break
				fi

			}

		fi

		}

	}

}


#move down
movedown(){

for((j=0;j<4;j++)){
	local isaddable=1
	for((i=2;i>=0;i--))
	{

		if((arr[$i,$j]!=0))
		then

			for((k=i;k<3;k++))
			{

				if((arr[$((k+1)),$j]==0))
				then
					arr[$((k+1)),$j]=${arr[$k,$j]}
					arr[$k,$j]=0
				elif (( arr[$k,$j] == arr[$((k+1)),$j] && isaddable == 1 ));
				then
					arr[$((k+1)),$j]=$(( arr[$k,$j]*2 ))
					Score=$(( arr[$k,$j] + Score))
					arr[$k,$j]=0
					isaddable=0
				else
					break
				fi

			}

		fi

	}

}

}








#moveright
moveright(){

for((i=0;i<4;i++)){

	isaddable=1

	for((j=2;j>=0;j--))
	{

		if((arr[$i,$j]!=0))
		then

			for((k=j;k<3;k++))
			{

				if((arr[$i,$((k+1))]==0))
				then
					arr[$i,$((k+1))]=${arr[$i,$k]}
					arr[$i,$k]=0
				elif [ ${arr[$i,$k]} -eq ${arr[$i,$((k+1))]} ] && [ $isaddable -eq 1 ];
				then
					{arr[$i,$((k+1))]=$(( arr[$i,$k]*2 ))
					Score=$(( arr[$i,$k] + Score))
					arr[$i,$k]=0
					local isaddable=0
				else
					break
				fi

			}

		fi

	}

}

}











#moverleft
moveleft(){

#outer loop starts
for((i=0;i<4;i++)){

	isaddable=1

	for((j=1;j<4;j++))
	{

		if((arr[$i,$j]!=0))
			then

			for((k=j;k>0;k--))
			{

				if((arr[$i,$((k-1))]==0))
				then
					arr[$i,$((k-1))]=${arr[$i,$k]}
					arr[$i,$k]=0
				elif [ ${arr[$i,$k]} -eq ${arr[$i,$((k-1))]} ] && [ $isaddable -eq 1 ];
				then
					arr[$i,$((k-1))]=$(( arr[$i,$k]*2 ))
					Score=$(( arr[$i,$k] + Score))
					arr[$i,$k]=0
					local isaddable=0
				else
					break
				fi

			}

		fi

	}

}

}





#check GameOver
gameover(){

local -n ref=$1

for((i=0;i<4;i++))
{
	for((j=0;j<4;j++))
	{
		if (( arr[$i,$j]==0 ))
		then
			ref=1
			break
		fi
	}
}


for((i=0;i<4 && ref==0;i++))
{
	for((j=0;j<4;j++))
	{
		local t1=$i
		local t2=$((j+1))
		if (( $t1<4 && $t2<4 && arr[$i,$j]==arr[$t1,$t2] ))
		then
			ref=1
			break
		fi
		
		t1=$((i+1))
		t2=$j

		if (( $t1<4 && $t2<4 && arr[$i,$j]==arr[$t1,$t2]  ))
		then
			ref=1
			break
		fi
		
		t1=$((i-1))
		t2=$j
		if (( $t1>=0 && $t2>=0 && arr[$i,$j]==arr[$t1,$t2]  ))
		then
			ref=1
			break
		fi
		
		t1=$i
		t2=$(( j-1 ))
		if (( $t1>=0 && $t2>=0 && arr[$i,$j]==arr[$t1,$t2]  ))
		then
			ref=1
			break
		fi
	}
}



if [ $ref -eq 0 ]
then
	ref=0
fi

}






#controls
controls(){

	echo "Press w=UP"
	echo "Press s=DOWN"
	echo "Press a=LEFT"
	echo "Press d=RIGHT"
	echo "Press q=QUIT"
	echo "                     Player: $name"
	echo "                     Score: $Score"
	echo

}



#display
display(){

for((i=0;i<4;i++))
{
	for((j=0;j<4;j++))
	{
		if((arr[$i,$j]==0))
		then
			printf ".        "
		else
			printf "${arr[$i,$j]}        "
		fi
	}
	echo
}

}

#temp array initialize
tempArrInit(){

for((i=0;i<4;i++))
{
	for((j=0;j<4;j++))
	{
		local x=${arr[$i,$j]}
		tempArr[$i,$j]=$x
	}
}

}

#check Equal
checkEqual(){
for ((ii=0;ii<4;ii++))
{
	for ((jj=0;jj<4;jj++))
	{
		if [ ${tempArr[$ii,$jj]} -ne ${arr[$ii,$jj]} ]
		then
			return 0
		fi
	}
echo	
}

echo
return 1

}

initialize
controls


for ((;;))
{
	tempArrInit
	printf "\033c"
	controls
	display
	read -p"Enter :" input

	if [ "$input" = "w" ]
	then
		moveup
	elif [ "$input" = "s" ]
	then
		movedown
	elif [ "$input" = "d" ]
	then
		moveright
	elif [ "$input" = "a" ]
	then
		moveleft
	elif [ "$input" = "q" ]
	then
		break
	else
		echo "Wrong Input"
	fi

	gameover_checker=0
	gameover gameover_checker

	if [ $gameover_checker -eq 0 ] 
	then
		echo "_________GAME OVER_________"
		break
	fi

	checkEqual

	if [ $? -eq 0 ]
	then
		randomNumber
	fi
}



