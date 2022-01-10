import { useState, useEffect } from "react";
import { GetStaticPropsContext } from "next";
import { getContract } from "../../constants/utils";
import { ICandidate } from '../../constants/typings'
import styles from '../../styles/pages/Candidate.module.scss'


const Candidate = (props: ICandidate) => {
  const [electionStarted, setElectionStarted] = useState(false)
  const [electionEnded, setElectionEnded] = useState(false)
  const [hasMetamask, setHasMetamask] = useState(false)
  const [hasVoted, setHasVoted] = useState(false)

  const candidate = props

  const init = async () => {
    const { ethereum } = window as any
    if (ethereum) {
      setHasMetamask(true)
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      const VotingContract = await getContract();
      const didVote = await VotingContract.methods.getHasVoted().call({ from: accounts[0] })
      if (didVote) {
        // console.log('hasVoted', didVote)
        setHasVoted(true)
      }
      // console.log('didVote', didVote)
      // console.log("Connected", accounts[0]);
      // console.log('candidate', candidate)

      const electionStarted = await VotingContract.methods.electionStarted.call().call()

      if (electionStarted) {
        setElectionStarted(true)
      }
      // console.log('electionStarted', electionStarted)
      const electionEnded = await VotingContract.methods.electionEnded.call().call()

      if (electionEnded) {
        setElectionEnded(true)
      }
      // console.log('electionEnded', electionEnded)

    }
  }

  const vote = async () => {
    try {
      console.log('vote')
      const { ethereum } = window as any
      if (ethereum) {
        const accounts = await ethereum.request({ method: "eth_requestAccounts" });
        const VotingContract = await getContract();
        console.log('candidate.index:', candidate.candidateId)
        const voteCandidate = await VotingContract.methods.voteCandidate(Number(candidate.candidateId)).send({ from: accounts[0] })
        setHasVoted(true)
        console.log('voteCandidate', voteCandidate)
      }
    } catch (err) {
      console.error(err)
      // alert('Can\'t vote, Please wait for the election to start')
    }
  }

  useEffect(() => {
    (async () => {
      await init()
    })()
  }, [])

  const Button = () => {
    console.log('hasVoted', hasVoted)
    console.log('electionStarted', electionStarted)
    console.log('electionEnded', electionEnded)
    if (electionStarted && hasMetamask && hasVoted && !electionEnded) {
      return (<div className={styles.CandidateDisable}>
        You already voted
      </div>)
    } else if (!hasMetamask) {
      return (
        <div className={styles.CandidateDisable}>
          Install Metamask
        </div>
      )
    } else if (!electionStarted) {
      return (
        <div className={styles.CandidateDisable}>
          Election not started
        </div>
      )
    } else if (electionStarted && !electionEnded && hasVoted) {
      return (
        (
          <div className={styles.CandidateDisable}>
            Election not Ended
          </div>
        )
      )
    } else if (electionStarted && !electionEnded && !hasVoted) {
      return (
        <button className={styles.Button} onClick={vote}>
          Vote {candidate.name}
        </button>
      )
    } else {
      return (
        <div className={styles.CandidateDisable}>
          Election ended
        </div>
      )
    }
  }

  return (
    <div className={styles.Candidate}>
      <div className={styles.CandidateLeft}>
        <img
          src={candidate.picUrl}
          alt={candidate.name}
          width={300}
          height={300}
        />
      </div>
      <div className={styles.CandidateRight}>
        <div>{candidate.name}</div>
        <div>{candidate.descUrl}</div>
        <div>Vote: {candidate.votes}</div>
        <div>
          {
            hasVoted
          }
          {
            Button()
          }

        </div>
      </div>
    </div>
  )
}

export const getStaticProps = async (context: GetStaticPropsContext) => {
  const candidateId = context?.params?.candidateId;
  const VotingContract = await getContract()
  const candidate = await VotingContract.methods.getCandidate(candidateId).call()
  const [name, descUrl, picUrl, votes] = candidate
  return {
    props: {
      candidateId,
      name, descUrl, picUrl, votes
    }
  }
}

export const getStaticPaths = async () => {
  if (!process.env.contractAddress) {
    return { notFound: true };
  }
  const VotingContract = await getContract()
  const candidates = await VotingContract.methods.getCandidates().call()
  const mappedCandidates = candidates.map((candidate: string, index: number) => {
    return {
      params: {
        candidateId: String(index)
      },
    }
  })
  return {
    paths: mappedCandidates,
    fallback: true
  }
}

export default Candidate