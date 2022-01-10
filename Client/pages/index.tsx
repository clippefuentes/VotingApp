import { useEffect, useState } from 'react'
import type { NextPage } from 'next'
import Head from 'next/head'
import Link from 'next/link'

import { ICandidate } from '../constants/typings'
import { getContract } from '../constants/utils'
import styles from '../styles/pages/Home.module.scss'

const Home: NextPage = () => {
  const [electionEnded, setElectionEnded] = useState(false)
  const [winner, setWinner] = useState<ICandidate | null>(null)
  const [isCommissioner, setCommissioner] = useState(false)
  const [address, setAddress] = useState('')

  const init = async () => {
    const { ethereum } = window as any
    if (ethereum) {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      const VotingContract = await getContract();
      const commissioner = await VotingContract.methods.commissioner.call().call()
      console.log('commissioner', commissioner)
      setAddress(accounts[0])
      console.log("Connected", accounts[0]);
      if (commissioner.toLocaleLowerCase() === accounts[0].toLocaleLowerCase()) {
        setCommissioner(true)
      }
      const electionEnded = await VotingContract.methods.electionEnded.call().call()

      if (electionEnded) {
        setElectionEnded(true)
        const winner = await VotingContract.methods.winner.call().call()
        console.log('winner', winner)
        setWinner(winner)
      }
    }
  }

  useEffect(() => {
    (async () => {
      await init()
    }
    )()
  })
  return (
    <div className={styles.Container}>
      <Head>
        <title>Voting Election</title>
        <meta name="description" content="Voting practice app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.Main}>
        <h1 className={styles.Title}>
          Welcome to the 2022 Election for the Next Leader of the Metaverse <br />
        </h1>
        <div>
          { electionEnded && winner && (
            <div>
              <div className={styles.Winner}>
                <h1>WINNER</h1>
                <img 
                  src={winner.picUrl}
                  alt={winner.name}
                  width={300}
                  height={300}
                />
                <h2>{winner.name}</h2>
                <h3>Votes: {winner.votes}</h3>
                <h4>{winner.descUrl}</h4>
              </div>
            </div>
          )
          
          }
        </div>
        <div className={styles.ButtonGroup}>
          <Link href="/candidates">
            <button className={styles.HomeButton}>
              See Candidates
            </button>
          </Link>
          {
            isCommissioner &&
            <Link href="/admin">
              <button className={styles.HomeButton}>
                Go To Admin
              </button>
            </Link>
          }
        </div>
      </main>
    </div>
  )
}

export default Home
