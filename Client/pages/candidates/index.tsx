import { useEffect } from "react";
import { GetStaticPropsContext } from "next";
import Web3 from 'web3'
import Voting from '../../constants/abi/Voting.json'
import { Candidates } from '../../constants/typings'
import CandidateBox from '../../components/CandidateBox'
import styles from '../../styles/pages/Candidates.module.scss'

interface CandidateProps {
  candidates: Candidates
}

const Candidate = (props: CandidateProps) => {
  const candidates = props.candidates ? props.candidates : []

  useEffect(() => {
    console.log('candidates', candidates)
  }, [candidates])

  return (
    <div className={styles.candidates}>
      <div className={styles.candidateTitle}>List Of Candidates</div>
      <div className={styles.candidatesList}>
        {candidates.map((candidate) => <CandidateBox key={candidate.name} candidate={candidate} />)}
      </div>
    </div>
  )
}

export const getStaticProps = async (context: GetStaticPropsContext) => {
  if (!process.env.contractAddress) {
    return { notFound: true };
  }
  const provider = new Web3.providers.HttpProvider('http://localhost:8545')
  const web3 = new Web3(provider)
  const VotingABI: any = Voting.abi
  const VotingContract = new web3.eth.Contract(VotingABI, process.env.contractAddress)
  const candidates = await VotingContract.methods.getCandidates().call()
  const mappedCandidates = candidates.map((candidate: string, index: number) => {
    return {
      index,
      name: candidate[0],
      descUrl: candidate[1],
      picUrl: candidate[2],
      votes: Number(candidate[3])
    }
  })
  return {
    props: {
      candidates: mappedCandidates
    }
  }
}


export default Candidate