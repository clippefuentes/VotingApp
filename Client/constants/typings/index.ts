export interface ICandidate {
  index?: number;
  candidateId?: number;
  name: string;
  descUrl: string;
  picUrl: string;
  votes: number;
}

export type Candidates = ICandidate[];