import { GetStaticPropsContext, GetStaticPathsContext } from "next";

interface Candidate {
  candidateId: string;
}

const Candidate = (props: Candidate) => {
  const { candidateId } = props;
  return (<div>
    Candidate Number {candidateId}
  </div>)
}

export const getStaticProps = async (context: GetStaticPropsContext) => {
  const candidateId = context?.params?.candidateId;
  return {
    props: {
      candidateId
    }
  }
}

export const getStaticPaths = async () => {
  // const paths = await getCandidates()
  const paths = [
    { params: { candidateId: '1' } },
    { params: { candidateId: '12' } },
  ]
  return {
    paths,
    fallback: true
  } 
}

export default Candidate