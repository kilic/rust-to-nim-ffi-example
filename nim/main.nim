const libName* = "../rust/target/debug/libbaby.dylib"

# example 1
proc emptyFunction*() :bool{.importc: "empty_function", dynlib: libName.}
var success = emptyFunction()
echo success


# example 2
proc add*(c: ptr cuint, a: ptr cuint; b: ptr cuint) :bool {.importc: "add", dynlib: libName.}
var a: cuint = 10
var b: cuint = 11
var c: cuint = 0
success = add(addr c, addr a, addr b)
echo success
echo c # must be equal to a + b


# example 3
type
  Buffer* = object
    `ptr`*: pointer
    len: csize_t

proc innerProd*(c:ptr Buffer, a:ptr Buffer, b:ptr Buffer):bool {.importc: "byte_inner_product", dynlib: libName.}
var aData: array[4, byte] = [byte(1), 2, 3, 4]
var bData: array[4, byte] = [byte(10), 10, 10, 10]
var cData: array[4, byte]
var len : csize_t = 4
var aBuffer = Buffer(`ptr`:unsafeAddr aData, len:len)
var bBuffer = Buffer(`ptr`:unsafeAddr bData, len:len)
var cBuffer = Buffer(`ptr`:unsafeAddr cData, len:len)

success = innerProd(unsafeAddr cBuffer, unsafeAddr aBuffer, unsafeAddr bBuffer)
echo success
var cDataCastedBack = cast[ptr array[4, byte]](cBuffer.`ptr`)[]
echo cDataCastedBack


# proc displayFormatted(format: cstring): cint {.importc: "printf", varargs, header: "stdio.h", discardable.}
# discard displayFormatted("My name is %s and I am %d years old!\n", "Ben", 30)





