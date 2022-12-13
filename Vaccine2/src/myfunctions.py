def calc_ordinal_loss(data,na_mask,rank_max=10,n_rep=20,n_iter_max=1000,method="KL",eps=1E-10):
    err_summary=[]
    result=[]
    ages_array=[]
    # テンソルのサイズ
    a_max=len(data)
    b_max=len(data[0].index)
    c_max=len(data[0].columns)
    # 以降使うマスクテンソル（.copyとしないと参照渡しになってしまう？）
    mask = np.array(na_mask.copy())
    for i in data:
        d_array = np.array(i)
        d_array=d_array.tolist()
        ages_array.append(d_array) 
    # 全座標の組み合わせをall_locに格納（オリジナルデータと、再構築データの誤差の計算用）
    all_loc=[]
    for i in range(a_max):
        for j in range(b_max):
            for k in range(c_max):
                all_loc.append([i,j,k])
    # trial数（20-50）だけ同じ計算を実行
    for n in range(n_rep):
        data_original=np.array(ages_array)
        err=[]
        # 1 - 10までランクを探索
        for i in range(1,rank_max+1):
            # Non-negative CP Decomposition（ランクはi、1000イタレーション、初期値はランダム、マスクあり、初期値はランダム）
            res=tsd.non_negative_parafac(tensor=data_original, rank=i, n_iter_max=n_iter_max, mask=mask, init="random")
            res=tsc.cp_to_tensor(res)
            # 再構築誤差
            losssum=[]
            for j in all_loc:
                x=data_original[j[0],j[1],j[2]]
                y=res[j[0],j[1],j[2]]
                if method=="MSE":
                    loss=(x-y)**2
                elif method == "KL":
                    loss=x*math.log(x/y)-x+y
                losssum.append(loss)
            # errにlossを追加
            err.append(sum(losssum)/len(all_loc))
        # err_summaryにerrを追加
        err_summary.append(err)
    # Pandasのデータフレームに変換
    err_summary=pd.DataFrame(err_summary)
    # resultに各ランクごとのTrialの平均値を計算
    for i in range(rank_max):
        result.append(np.average(err_summary[i]))
    return result,err_summary