package util;

enum Result<T> {
    Failure(reason:String);
    Success(data:T);
}