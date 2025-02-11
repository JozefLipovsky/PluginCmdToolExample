import PackagePlugin
import Foundation

@main
struct CmdToolPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let swift = try context.tool(named: "swift")
        print("CmdToolPlugin - swift tool: \(swift.url)")

        let process = Process()
        process.executableURL = swift.url
        process.arguments = arguments

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        print("CmdToolPlugin - running with arguments: \(process.arguments ?? ["Missing Arguments!!!"])")
        try process.run()


        let timeout: TimeInterval = 3
        let startTime = Date()

        while process.isRunning {
            if Date().timeIntervalSince(startTime) > timeout {
                process.terminate()
                print("CmdToolPlugin - process timed out and was terminated.")
                break
            }

            try await Task.sleep(for: .seconds(1))
        }

        process.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        if let outputString = String(data: outputData, encoding: .utf8), !outputString.isEmpty {
            print("CmdToolPlugin - process output: \(outputString)")
        }

        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        if let errorString = String(data: errorData, encoding: .utf8), !errorString.isEmpty {
            print("CmdToolPlugin - process error: \(errorString)")
        }

        let status = process.terminationStatus
        print("CmdToolPlugin - process exited with status: \(status)")
    }
}
