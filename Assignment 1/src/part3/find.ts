import { Result, makeFailure, makeOk, bind, either } from "../lib/result";

/* Library code */
const findOrThrow = <T>(pred: (x: T) => boolean, a: T[]): T => {
    for (let i = 0; i < a.length; i++) {
        if (pred(a[i])) return a[i];
    }
    throw "No element found.";
}

export const findResult = <T>(pred: (x: T) => boolean, a: T[]): Result<T> =>{
    const isOk = (element: T) => pred(element);
    let index = a.findIndex(isOk);
    if (index != -1) { 
        let ok: Result<T> = {tag : "Ok", value : a[index] };
        return ok;
    }
    let Failure: Result<T>={tag : "Failure", message:"Fail" };
    return Failure;
};
/* Client code */
const returnSquaredIfFoundEven_v1 = (a: number[]): number => {
    try {
        const x = findOrThrow(x => x % 2 === 0, a);
        return x * x;
    } catch (e) {
        return -1;
    }
}

export const v2Helper = (n:number): Result<number> => {
    let x : Result<number> = {tag:"Ok", value: n*n};
    return x;
}
export const v3Helper = (n:number): number => {
    let x : Result<number> = {tag:"Ok", value: n*n};
    return x.value;
}

export const returnSquaredIfFoundEven_v2 = (a: number[]): Result<number> => {
    return bind(findResult(x=> x%2 === 0, a),b=> v2Helper(b));
};

export const returnSquaredIfFoundEven_v3 = (a: number[]): number => {
    return either(findResult(x=> x%2 === 0, a),b=> v3Helper(b),b=> -1);
};