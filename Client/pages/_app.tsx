import { useEffect, useState } from 'react'
import Head from 'next/head'
import type { AppProps } from 'next/app'
import globalStyles from '../styles/globals.module.scss';
// import Web3 from 'web3'

function MyApp({ Component, pageProps }: AppProps) {
  const [hasMetamask, setHasMetamask] = useState(false)
  const [initialLoad, setInitialLoad] = useState(false)
  useEffect(() => {
    try {
      const { ethereum } = window as any
      console.log('etheruem', ethereum)
      // const provider = new Web3.providers.HttpProvider('http://localhost:7545')
      // const web3 = new Web3(provider)
      // console.log(web3Instance)
      
      if (!ethereum) {
        setHasMetamask(false)
        alert('Get MetaMask!');
        return;
      }
      setHasMetamask(true)

    } catch (err: unknown) {
      console.error(err)
    }

    setInitialLoad(true)
  }, [])

  return (
    <div className={globalStyles.root}>
      <Head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:ital,wght@0,200;0,300;0,400;0,600;0,700;0,900;1,200;1,300;1,400;1,600;1,700;1,900&display=swap" rel="stylesheet" />
      </Head>
      {!initialLoad && <div>Loading...</div>}
      {initialLoad && !hasMetamask && <div>Get MetaMask!</div>}
      {initialLoad && hasMetamask && <Component {...pageProps} />}
    </div>
  )

}

export default MyApp
