import { GetStaticPropsContext, GetStaticPathsContext } from "next";

const Candidate = () => {
  return (<div>
    List Of Candidates
  </div>)
}

// export const getStaticProps = async (context: GetStaticPropsContext) => {
//   const candidateId = context?.params?.candidateId;
//   return {
//     props: {
//       candidateId
//     }
//   }
// }
export default Candidate