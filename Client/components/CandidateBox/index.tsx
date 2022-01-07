import { ICandidate } from '../../constants/typings/index'
import styles from '../../styles/components/CandidateBox.module.scss'

interface CandidateBoxProps {
  candidate: ICandidate
}

function CandidateBox(props: CandidateBoxProps) {
  const { candidate } = props
  return (
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
      <div className={styles.candidateBoxInfo}>
        <div>
          <div className={styles.candidateBoxInfoName}>{candidate.name}</div>
          <div className={styles.candidateBoxInfoDescUrl}>{candidate.descUrl}</div>
        </div>
      </div>
    </div>
  )

}

export default CandidateBox;