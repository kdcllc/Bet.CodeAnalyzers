using Microsoft.Build.Utilities;
using System;
using System.IO;

namespace Bet.EditorConfig
{
    public class InstallEditorConfigTask : Task
    {
        private readonly string _fileName = ".editorconfig";

        public string ProjectDir { get; set; }

        public string ReferenceEditorConfig { get; set; }

        public bool Override { get; set; }

        public override bool Execute()
        {
            Log.LogMessage("Started");
            Log.LogMessage($"Destination: {ProjectDir} and Source: {ReferenceEditorConfig}");

            if (string.IsNullOrEmpty(ReferenceEditorConfig))
            {
                ReferenceEditorConfig = Path.Combine(AppContext.BaseDirectory, _fileName);
                Log.LogMessage($"Update location {ReferenceEditorConfig}");
            }

            try
            {
                var dest = Path.Combine(ProjectDir, _fileName);

                if (!File.Exists(Path.Combine(ProjectDir, _fileName)))
                {
                    File.Copy(ReferenceEditorConfig, dest, true);
                }
            }
            catch (Exception ex)
            {
                Log.LogErrorFromException(ex);
            }

            Log.LogMessage("Ended");

            return true;
        }
    }
}
