import { ProposalVote } from "@/configure/vote";

export const voteAddress="0x74Dfc3E2c7e0d0a728e8803f0c7ABdB7D2FD6f66"

//创建提案
export async function createProposal(wallet,_title,_details,_votingStartTime,_votingEndTime,callback) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    await createProposalEstimateGas(contract,wallet,_title,_details,_votingStartTime,_votingEndTime)
    function _createProposal(contract,web3,address,_title,_details,_votingStartTime,_votingEndTime, callback) {
        return new Promise((resolve, reject) => {
            contract.methods.createProposal(_title,_details,_votingStartTime,_votingEndTime).send({from: address}).on('transactionHash', function (hash) {
                callback({
                    message: hash,
                    options: {
                        key: new Date().getTime() + Math.random(),
                        variant: 'success'
                    },
                    hash
                });
            }).on('receipt', function (receipt) {
                console.log(receipt);
                resolve(receipt)
            }).on('error', function (error) {
                console.log(error)
                reject(error)
            }).catch((error) => {
                console.log(error)
                reject(error)
            })
        })
    }

    return  _createProposal(wallet.web3, wallet.address,_title,_details,_votingStartTime,_votingEndTime,callback)
}

//创建提案报错预知
export async function createProposalEstimateGas(contract,wallet, _title,_details,_votingStartTime,_votingEndTime) {
    let web3=wallet.web3
    let txObject = {
        from: wallet.address,
        to: voteAddress,
        data:contract.methods.createProposal(_title,_details,_votingStartTime,_votingEndTime).encodeABI()
    }
    return new Promise(async (resolve, reject) => {
        web3.eth.estimateGas(txObject).then(res => {
            resolve(res)
        }).catch((err) => {
            reject(err)
        })
    })
}

//编辑提案
export async function editProposal(wallet,_id,_title,_details,_votingStartTime,_votingEndTime,callback) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    await editProposalEstimateGas(contract,wallet,_id,_title,_details,_votingStartTime,_votingEndTime)
    function _editProposal(contract,web3,address,_id,_title,_details,_votingStartTime,_votingEndTime, callback) {
        return new Promise((resolve, reject) => {
            contract.methods.editProposal(_id,_title,_details,_votingStartTime,_votingEndTime).send({from: address}).on('transactionHash', function (hash) {
                callback({
                    message: hash,
                    options: {
                        key: new Date().getTime() + Math.random(),
                        variant: 'success'
                    },
                    hash
                });
            }).on('receipt', function (receipt) {
                console.log(receipt);
                resolve(receipt)
            }).on('error', function (error) {
                console.log(error)
                reject(error)
            }).catch((error) => {
                console.log(error)
                reject(error)
            })
        })
    }

    return  _editProposal(wallet.web3, wallet.address,_id,_title,_details,_votingStartTime,_votingEndTime,callback)
}

//编辑提案报错预知
export async function editProposalEstimateGas(contract,wallet,_id, _title,_details,_votingStartTime,_votingEndTime) {
    let web3=wallet.web3
    let txObject = {
        from: wallet.address,
        to: voteAddress,
        data:contract.methods.editProposal(_id,_title,_details,_votingStartTime,_votingEndTime).encodeABI()
    }
    return new Promise(async (resolve, reject) => {
        web3.eth.estimateGas(txObject).then(res => {
            resolve(res)
        }).catch((err) => {
            reject(err)
        })
    })
}

//对提案进行投票
export async function voteProposal(wallet,id,auth,callback) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    await voteProposalEstimateGas(contract,wallet,id,auth)
    function _voteProposal(contract,web3,address,id,auth, callback) {
        return new Promise((resolve, reject) => {
            contract.methods.voteProposal(id,auth).send({from: address}).on('transactionHash', function (hash) {
                callback({
                    message: hash,
                    options: {
                        key: new Date().getTime() + Math.random(),
                        variant: 'success'
                    },
                    hash
                });
            }).on('receipt', function (receipt) {
                console.log(receipt);
                resolve(receipt)
            }).on('error', function (error) {
                console.log(error)
                reject(error)
            }).catch((error) => {
                console.log(error)
                reject(error)
            })
        })
    }

    return  _voteProposal(wallet.web3, wallet.address,id,auth,callback)
}

//对提案投票报错预知
export async function voteProposalEstimateGas(contract,wallet,id,auth) {
    let web3=wallet.web3
    let txObject = {
        from: wallet.address,
        to: voteAddress,
        data:contract.methods.voteProposal(id,auth).encodeABI()
    }
    return new Promise(async (resolve, reject) => {
        web3.eth.estimateGas(txObject).then(res => {
            resolve(res)
        }).catch((err) => {
            reject(err)
        })
    })
}

//添加白名单
export async function addWhiteList(wallet,_addr,callback) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    await addWhiteListEstimateGas(contract,wallet,_addr)
    function _addWhiteList(contract,web3,address,_addr, callback) {
        return new Promise((resolve, reject) => {
            contract.methods.addWhiteList(_addr).send({from: address}).on('transactionHash', function (hash) {
                callback({
                    message: hash,
                    options: {
                        key: new Date().getTime() + Math.random(),
                        variant: 'success'
                    },
                    hash
                });
            }).on('receipt', function (receipt) {
                console.log(receipt);
                resolve(receipt)
            }).on('error', function (error) {
                console.log(error)
                reject(error)
            }).catch((error) => {
                console.log(error)
                reject(error)
            })
        })
    }

    return  _addWhiteList(wallet.web3, wallet.address,_addr,callback)
}

//对提案投票报错预知
export async function addWhiteListEstimateGas(contract,wallet,_addr) {
    let web3=wallet.web3
    let txObject = {
        from: wallet.address,
        to: voteAddress,
        data:contract.methods.addWhiteList(_addr).encodeABI()
    }
    return new Promise(async (resolve, reject) => {
        web3.eth.estimateGas(txObject).then(res => {
            resolve(res)
        }).catch((err) => {
            reject(err)
        })
    })
}

//获取提案信息：提案地址、标题、详情、创建时间、同意个数、否决个数、投票开始时间、投票结束时间
export async function proposals(wallet) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    return contract.methods.proposals().call({from: wallet.address})
}

//获取本人投票信息：返回投票人地址、投票时间、投票布尔值、投票权重，其中如歌投票时间和权重为0表示此用户未投票该提案
export async function votes(wallet,address,id) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    return contract.methods.votes(address,id).call({from: wallet.address})
}

//分页查询返回提案id列表
export async function proposalIdsList(wallet,page,size) {
    const contract = new wallet.web3.eth.Contract(ProposalVote.abi, voteAddress)
    return contract.methods.proposalIdsList(page,size).call({from: wallet.address})
}