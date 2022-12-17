i="0"
iter="5"
mkdir -p logs
rm -rf ./ckpt/*
wait_function () {
    sleep 10
    for job in `jobs -p`
    do
        echo $job
        wait $job || let "FAIL+=1"
    done
}
set -x
while [ $i -lt $iter ]
do

    python dnn_train.py --timestamp=$i  --algo=PointWise --loss=ce > logs/dnn_point_train_$i.log  2>&1 &
    python dnn_train.py --timestamp=$i  --algo=PairWise --loss=logistic > logs/dnn_pair_train_$i.log  2>&1 &
    wait_function

    python dnn_test.py --timestamp=$i  --algo=PointWise --loss=ce > logs/dnn_point_test_$i.log  2>&1 &
    python dnn_test.py --timestamp=$i  --algo=PairWise --loss=logistic > logs/dnn_pair_test_$i.log  2>&1 &
    wait_function

    python dnn_train.py --timestamp=$i  --algo=ListWise --loss=listNet > logs/dnn_list_train_$i.log  2>&1 &
    #python dnn_train.py --timestamp=$i  --algo=GroupWise  > logs/dnn_group_train_$i.log  2>&1 &
    python dnn_train.py --timestamp=$i  --algo=SoftRank  > logs/dnn_softrank_train_$i.log  2>&1 &
    wait_function

    python dnn_test.py --timestamp=$i  --algo=ListWise --loss=listNet > logs/dnn_list_test_$i.log  2>&1 &
    #python dnn_test.py --timestamp=$i  --algo=GroupWise  > logs/dnn_group_test_$i.log  2>&1 &
    python dnn_test.py --timestamp=$i  --algo=SoftRank  > logs/dnn_softrank_test_$i.log  2>&1 &
    wait_function

    python dqn_train.py --timestamp=$i > logs/dqn_train_$i.log  2>&1 &
    wait_function
    python dqn_test.py --timestamp=$i > logs/dqn_test_$i.log  2>&1 &
    wait_function

    python MonteCarlo_train.py --timestamp=$i > logs/monte_carlo_train_$i.log  2>&1 &
    wait_function
    python MonteCarlo_test.py --timestamp=$i > logs/monte_carlo_test_$i.log  2>&1 &
    wait_function
    
    python ppo_gae_train.py --timestamp=$i > logs/ppo_gae_train_$i.log  2>&1 &
    wait_function
    python ppo_gae_test.py --timestamp=$i > logs/ppo_gae_test_$i.log  2>&1 &
    wait_function

    python ppo_gae_train.py --algo=pcl --timestamp=$i > logs/pcl_train_$i.log  2>&1 &
    wait_function
    python ppo_gae_test.py --algo=pcl --timestamp=$i > logs/pcl_test_$i.log  2>&1 &
    wait_function

    python ppo_plus_train.py --timestamp=$i > logs/ppo_plus_train_$i.log  2>&1 &
    wait_function
    python ppo_plus_test.py --timestamp=$i > logs/ppo_plus_test_$i.log  2>&1 &
    wait_function

    python ppo_train.py --timestamp=$i > logs/ppo_train_$i.log  2>&1 &
    wait_function
    python ppo_test.py --timestamp=$i > logs/ppo_test_$i.log  2>&1 &
    wait_function

    python prm_train.py --timestamp=$i > logs/prm_train_$i.log  2>&1 &
    python seq2slate_train.py --timestamp=$i > logs/seq2slate_train_$i.log  2>&1 &
    wait_function

    python prm_test.py --timestamp=$i > logs/prm_test_$i.log  2>&1 &
    python seq2slate_test.py --timestamp=$i > logs/seq2slate_test_$i.log  2>&1 &
    wait_function 
i=$[$i+1]
done

find logs -type f -name "*test*log" -exec awk '{s=$0};END{print FILENAME,s}' {} \; | sort