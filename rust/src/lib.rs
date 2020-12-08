use std::slice;

#[repr(C)]
#[derive(Clone, Debug, PartialEq)]
pub struct Buffer {
    pub ptr: *const u8,
    pub len: usize,
}

impl From<&[u8]> for Buffer {
    fn from(src: &[u8]) -> Self {
        Self {
            ptr: &src[0] as *const u8,
            len: src.len(),
        }
    }
}

impl<'a> From<&Buffer> for &'a [u8] {
    fn from(src: &Buffer) -> &'a [u8] {
        unsafe { slice::from_raw_parts(src.ptr, src.len) }
    }
}

#[no_mangle]
pub extern "C" fn empty_function() -> bool {
    true
}

#[no_mangle]
pub extern "C" fn add(c: *mut u32, a: *const u32, b: *const u32) -> bool {
    let a: u32 = unsafe { *a };
    let b: u32 = unsafe { *b };
    unsafe { *c = a + b };
    true
}

#[no_mangle]
pub extern "C" fn byte_inner_product(c: *mut Buffer, a: *const Buffer, b: *const Buffer) -> bool {
    let a_data = <&[u8]>::from(unsafe { &*a });
    let b_data = <&[u8]>::from(unsafe { &*b });

    let n = a_data.len();
    assert_eq!(n, b_data.len());
    let mut c_data: Vec<u8> = Vec::with_capacity(n);
    for (a, b) in a_data.iter().zip(b_data.iter()) {
        let a = *a;
        let b = *b;
        let c = a * b;
        c_data.push(c);
    }

    unsafe { *c = Buffer::from(&c_data[..]) };
    std::mem::forget(c_data);
    true
}
