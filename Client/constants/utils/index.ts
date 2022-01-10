import Web3 from 'web3'
import Voting from '../abi/Voting.json'

export const getContract = async () => {
  try {
    const provider = new Web3.providers.HttpProvider(process.env.httpProvider || '')
    const web3 = new Web3(provider)
    const VotingABI: any = Voting.abi
    const VotingContract = new web3.eth.Contract(VotingABI, process.env.contractAddress)
    return VotingContract
  } catch (err: any) {
    console.error(err)
    throw new Error(err)
  }
}