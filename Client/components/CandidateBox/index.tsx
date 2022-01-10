import Link from 'next/link'
import { ICandidate } from '../../constants/typings/index'
import styles from '../../styles/components/CandidateBox.module.scss'

interface CandidateBoxProps {
  candidate: ICandidate
}

function CandidateBox(props: CandidateBoxProps) {
  const { candidate } = props
  console.log('index', candidate.index)
  return (
    <Link href={`/candidates/${candidate.index}`}>
      <div className={styles.candidateBox}>
        <div className={styles.candidateBoxHeader}>
          <img
            className={styles.candidateBoxImage}
            src={candidate.picUrl}
            alt={candidate.name}
            width={300}
            height={300}
          />
        </div>
        <div className={styles.candidateBoxFooter}>
          <div className={styles.candidateBoxInfo}>
            <div className={styles.candidateBoxInfoBox}>
              <div className={styles.candidateBoxInfoName}>{candidate.name}:</div>
              <div className={styles.candidateBoxInfoDescUrl}>{candidate.descUrl}</div>
            </div>
          </div>
        </div>
      </div>
    </Link>
  )

}

export default CandidateBox;