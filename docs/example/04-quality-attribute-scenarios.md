# Quality-attribute scenarios

| ID | Attribute | Source | Stimulus | Environment | Artifact | Expected response | Measure |
|---|---|---|---|---|---|---|---|
| QAS-01 | Reliability | Carrier API retry | Duplicate callback for the same shipment request arrives after initial success | Production traffic with intermittent carrier retries | Fulfillment state machine | One shipment transition is persisted and the duplicate event is logged as ignored | 0 duplicate shipment transitions for the same idempotency key |
| QAS-02 | Availability | Carrier outage | Carrier times out for 5 minutes during peak order intake | Peak weekday traffic | Order intake and fulfillment routing | Order API returns accepted response with `PendingFulfillment` state in under 2 seconds and resumes async fulfillment later | p95 intake latency under 2 seconds during outage |
| QAS-03 | Modifiability | Extraction change | Routing is switched from extracted fulfillment path back to legacy path after anomaly detection | Controlled migration window | Routing seam and outbox path | New traffic returns to legacy path in under 5 minutes without data loss | Rollback executed in under 5 minutes with zero lost order events |
