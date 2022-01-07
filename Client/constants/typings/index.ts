export interface ICandidate {
  name: string;
  descUrl: string;
  picUrl: string;
  votes: number;
}

export type Candidates = ICandidate[];