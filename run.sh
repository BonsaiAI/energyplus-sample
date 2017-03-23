# ! /usr/bin/bash

echo "architect/should_use_q_table_safe_guard should be set to True"
echo "run gulp build from within bde.py enter-web"

case "$1" in
train)
	echo "training"
	python3 energyplus_simulator.py --train-brain energyplus
	;;
predict)
	echo "predicting"
	python3 energyplus_simulator.py --predict-brain=energyplus --predict-version=latest
	;;
clean)
	echo "cleaning"
	rm output*
	rm *.log
	;;
*)
	echo $"usage $0 {train|predict|clean}"
esac