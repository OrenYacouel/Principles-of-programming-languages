import * as R from "ramda";

const stringToArray = R.split("");

/* Question 1 */
export const countLetters= (s: string): {} => {
    let func = R.pipe(
        (s: string) => stringToArray(s), 
        (arr: string[]) => arr.filter(x => ((x >= 'a' && x <= 'z') || (x >= 'A' && x <= 'Z'))), 
        (arr: string[]) => R.countBy( R.toLower, arr)
    );
    return func(s);
}


/* Question 2 */
export const deletePairs= (arr: string[], ch: string): string[] =>{
  if(ch === "(" || ch === "{" || ch === "[") { 
    return R.prepend(ch, arr);
  } else if(ch === ")"){ return remove(arr, "(", ch);}
  else if(ch === "}"){ return remove(arr, "{", ch);}
  else if(ch === "]"){ return remove(arr, "[", ch);}
  else{ return arr; }
}

export const remove = (arr: string[], open: string, close: string): string[] =>{
  if(R.isEmpty(arr)){
    return [close];
  }else if(R.head(arr) === open){
    return R.tail(arr); 
  }else{ return R.prepend(close, arr); }
}

export const isPaired= (s: string) : any =>{return R.pipe(
  stringToArray,
  R.reduce(deletePairs, []),
  R.isEmpty
)};


/* Question 3 */
export interface WordTree {
    root: string;
    children: WordTree[];
}

export const treeToSentence = (t: WordTree): string => {
    return t.root + t.children.reduce(func, "");
}

export const func = (acc: string, curr: WordTree): string =>{
  return acc + " " + treeToSentence(curr);
}

const t1: WordTree = { 
    root: "Hello", 
    children: [ 
        { 
            root: "students", 
            children: [ 
                { 
                    root: "how", 
                    children: [] 
                } 
            ] 
        }, 
        { 
            root: "are", 
            children: [] 
        }, 
        { 
            root: "you?", 
            children: [] 
        }
    ]
}

console.log(treeToSentence(t1));



