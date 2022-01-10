require('dotenv').config({  path: `config/.env` });

/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  images: {
    domains: ['images.unsplash.com']
  },
  env: {
    contractAddress: process.env.REACT_APP_CONTRACT_ADDRESS || '',
    httpProvider: process.env.REACT_APP_HTTP_PROVIDER || '',
  }
}
