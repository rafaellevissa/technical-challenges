from fastapi import FastAPI

app = FastAPI(title="Mock S3 API")

@app.get("/")
def health_check():
    return {
        "status": "ok",
        "message": "Application is up and running"
    }


@app.get("/files")
def list_mock_s3_files():
    return {
        "bucket": "mock-bucket",
        "files": [
            {
                "key": "documents/report.pdf",
                "size": 245678,
                "last_modified": "2025-01-10T12:30:00Z"
            },
            {
                "key": "images/photo.png",
                "size": 134567,
                "last_modified": "2025-01-12T09:15:00Z"
            },
            {
                "key": "logs/app.log",
                "size": 98765,
                "last_modified": "2025-01-15T18:45:00Z"
            }
        ]
    }

