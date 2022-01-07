import type { NextPage } from 'next'
import Head from 'next/head'
import Link from 'next/link'
import styles from '../styles/pages/Home.module.scss'

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Voting Election</title>
        <meta name="description" content="Voting practice app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to the 2022 Election for the Next Leader of the Metaverse
        </h1>
        <div>
          <Link href="/candidates">
            See Candidates
           </Link>
        </div>
      </main>
    </div>
  )
}

export default Home
