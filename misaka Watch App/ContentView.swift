//
//  ContentView.swift
//  misaka Watch App
//
//  Created by mini on 2024/01/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Change Font") {
            if let data = FileManager.default.contents(atPath: Bundle.main.bundlePath+"/font.ttf") {
                if overwrite(odata: data, tpath: Bundle.main.executablePath!) {
                    respringFrontboard()
                }
            }
        }
    }
}

func overwrite(odata: Data, tpath: String) -> Bool {
    let fd = open(tpath, O_RDONLY | O_CLOEXEC)
    defer { close(fd) }
    let tsize = lseek(fd, 0, SEEK_END)
    guard tsize >= odata.count else { return false }
    let map = mmap(nil, odata.count, PROT_READ, MAP_SHARED, fd, 0)
    if map == MAP_FAILED { return false }
    guard mlock(map, odata.count) == 0 else { return false }
    for chunkOff in stride(from: 0, to: odata.count, by: 0x4000) {
        let dataChunk = odata[chunkOff..<min(odata.count, chunkOff + 0x4000)]
        var overwroteOne = false
        for _ in 0..<2 {
            let overwriteSucceeded = dataChunk.withUnsafeBytes { dataChunkBytes in
                return unaligned_copy_switch_race(
                    fd, Int64(chunkOff), dataChunkBytes.baseAddress, dataChunkBytes.count)
            }
            if overwriteSucceeded {
                overwroteOne = true
                break
            }
        }
        guard overwroteOne else { return false }
    }
    return true
}
