use std::ffi::{CStr, CString};
use std::os::raw::c_char;

pub fn remove_numbers(the_string: String) -> String {
    let mut result = String::new();
    for c in the_string.chars() {
        if !c.is_numeric() {
            result.push(c);
        }
    }

    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_remove_numbers() {
        let result = remove_numbers("abc123".to_string());
        assert_eq!(result, "abc");
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn remove_numbers_c(input: *const c_char) -> *mut c_char {
    if input.is_null() {
        return std::ptr::null_mut();
    }

    let c_str = unsafe { CStr::from_ptr(input) };
    let input_str = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => return std::ptr::null_mut(),
    };
    let result = remove_numbers(input_str.to_string());
    match CString::new(result) {
        Ok(c_string) => c_string.into_raw(),
        Err(_) => std::ptr::null_mut(),
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn free_string(s: *mut c_char) {
    if !s.is_null() {
        unsafe {
            let _ = CString::from_raw(s);
        }
    }
}