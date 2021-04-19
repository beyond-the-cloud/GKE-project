import time
from locust import HttpUser, task, between, events

mapping = {
    'v1': 0,
    'v2': 0
}

class QuickstartUser(HttpUser):
    wait_time = between(1, 2.5)

    @task
    def hello_world(self):
        response = self.client.get("/webapp/v1/helloworld")
        print(response.text)
        if '2' in response.text:
            mapping['v2'] += 1
        else:
            mapping['v1'] += 1

@events.test_stop.add_listener
def on_test_stop(environment, **kwargs):
    print('v1 / total: ')
    print('{:.2f}'.format(mapping['v1'] / (mapping['v1'] + mapping['v2']) * 100) + '%')
