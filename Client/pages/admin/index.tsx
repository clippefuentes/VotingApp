import { useState, useEffect } from "react";
import Router from "next/router";
import { getContract } from "../../constants/utils";
import styles from '../../styles/pages/Admin.module.scss'

const Admin = () => {
  const [electionStarted, setElectionStarted] = useState(false)
  const [electionEnded, setElectionEnded] = useState(false)

  const init = async () => {
    const { ethereum } = window as any
    if (ethereum) {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      const VotingContract = await getContract();
      const commissioner = await VotingContract.methods.commissioner.call().call()
      console.log('commissioner', commissioner)
      console.log("Connected", accounts[0]);
      if (commissioner.toLocaleLowerCase() !== accounts[0].toLocaleLowerCase()) {
        // setCommissioner(true)
        Router.push('/')
      }

      const electionStarted = await VotingContract.methods.electionStarted.call().call()

      if (electionStarted) {
        setElectionStarted(true)
      }
      console.log('electionStarted', electionStarted)
      const electionEnded = await VotingContract.methods.electionEnded.call().call()

      if (electionEnded) {
        setElectionEnded(true)
      }
      console.log('electionEnded', electionEnded)

    }
  }

  useEffect(() => {
    (async () => {
      await init()
    })()
  }, [])

  const startElection = async () => {
    const { ethereum } = window as any
    if (ethereum) {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      const VotingContract = await getContract();
      const startElection = await VotingContract.methods.startElection.call({ from: accounts[0] }).send({ from: accounts[0] })
      console.log('startElection', startElection)
    }
  }

  const endElection = async () => {
    const { ethereum } = window as any
    if (ethereum) {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      const VotingContract = await getContract();
      const startElection = await VotingContract.methods.endElection.call({ from: accounts[0], gas: 1000000 }).send({ from: accounts[0], gas: 1000000 })
      console.log('startElection', startElection)
    }
  }

  return (
    <div>
      <h1 className={styles.Title}>Admin</h1>
      <div className={styles.ButtonGroup}>
        {
          !electionStarted && !electionEnded && (
            <button className={styles.Button} onClick={startElection}>
              Start Election
            </button>
          )
        }
        {
          electionStarted && !electionEnded && (
            <button className={styles.Button} onClick={endElection}>
              End Election
            </button>
          )
        }
        
        {
          electionStarted && electionEnded && (
            <button className={styles.Button} disabled>
              Election Ended
            </button>
          )
        }
      </div>
    </div>
  )
}

export default Admin